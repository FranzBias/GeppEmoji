#!/usr/bin/env python3
"""
Build the emoji database for GeppEmoji.

This script parses the official Unicode emoji-test.txt file and generates
`emoji_data.json`, optionally applying local overrides from
`emoji_translations.json`.

- Download emoji-test.txt from:
  https://unicode.org/Public/emoji/latest/emoji-test.txt

- Put it in the same folder as this script (or let the script download it).

- Run:
    python3 build_emoji_db.py
"""

import urllib.request
import json
import re
import os
from urllib.error import URLError, HTTPError

EMOJI_TEST_URL = "https://unicode.org/Public/emoji/latest/emoji-test.txt"
LOCAL_EMOJI_TEST = "emoji-test.txt"
OUTPUT_FILE = "emoji_data.json"
TRANSLATIONS_FILE = "emoji_translations.json"


def load_local_emoji_test():
    """Try to load emoji-test.txt from the local directory."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), LOCAL_EMOJI_TEST)
    if os.path.exists(path):
        print(f"Using local {LOCAL_EMOJI_TEST} at {path}")
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    return None


def download_emoji_test():
    """Download emoji-test.txt from Unicode if no local file is available."""
    print(f"Downloading {EMOJI_TEST_URL} ...")
    try:
        with urllib.request.urlopen(EMOJI_TEST_URL) as resp:
            data = resp.read().decode("utf-8")
        print("Download completed.")
        return data
    except HTTPError as e:
        print(f"HTTP error while downloading emoji-test.txt: {e}")
    except URLError as e:
        print(f"URL error while downloading emoji-test.txt: {e}")
    except Exception as e:
        print(f"Unexpected error while downloading emoji-test.txt: {e}")
    return None


def save_local_emoji_test(text):
    """Save a copy of emoji-test.txt locally, for reproducible builds."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), LOCAL_EMOJI_TEST)
    try:
        with open(path, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"Saved a local copy to {path}")
    except Exception as e:
        print(f"Error while saving local emoji-test.txt: {e}")


def load_translations():
    """
    Load optional overrides / translations from emoji_translations.json.

    Expected structure:
    {
        "by_shortcode": {
            ":heart:": {
                "names": {"it": "cuore", "de": "Herz"},
                "keywords": {"it": ["cuore", "amore"]},
                "favorite": true,
                "category": "Smileys & Emotion",
                "extra": ["romantico"]
            },
            ...
        },
        "by_char": {
            "❤️": {
                "keywords": {"it": ["cuore", "amore"]},
                ...
            }
        }
    }
    """
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), TRANSLATIONS_FILE)
    if not os.path.exists(path):
        print("No translations file found (emoji_translations.json), continuing without overrides.")
        return {"by_shortcode": {}, "by_char": {}}

    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as e:
        print("Error reading emoji_translations.json:", e)
        return {"by_shortcode": {}, "by_char": {}}

    by_sc = data.get("by_shortcode", {}) or {}
    by_ch = data.get("by_char", {}) or {}
    print(f"Translations loaded: {len(by_sc)} by shortcode, {len(by_ch)} by char.")
    return {"by_shortcode": by_sc, "by_char": by_ch}


def apply_overrides(item, overrides):
    """
    Apply overrides from a dict to an emoji item.

    Supported keys:
    - names: dict per language
    - keywords: dict per language (merged with existing)
    - category: string
    - favorite: bool
    - extra: list of extra keywords (language independent)
    """
    # names
    if "names" in overrides and isinstance(overrides["names"], dict):
        names = item.setdefault("names", {})
        for lang, value in overrides["names"].items():
            names[lang] = value

    # keywords
    if "keywords" in overrides and isinstance(overrides["keywords"], dict):
        kw = item.setdefault("keywords", {})
        for lang, arr in overrides["keywords"].items():
            if not isinstance(arr, list):
                continue
            existing = kw.get(lang, [])
            # merge and deduplicate
            merged = sorted(set(existing + arr))
            kw[lang] = merged

    # category
    if "category" in overrides and isinstance(overrides["category"], str):
        item["category"] = overrides["category"]

    # favorite
    if "favorite" in overrides:
        item["favorite"] = bool(overrides["favorite"])

    # extra
    if "extra" in overrides and isinstance(overrides["extra"], list):
        extra = item.setdefault("extra", [])
        item["extra"] = sorted(set(extra + [str(x) for x in overrides["extra"]]))

    return item


def build_emoji_db(emoji_test_text, translations):
    """
    Parse the emoji-test.txt content and build a list of emoji entries.

    Each entry is a dict like:
    {
        "char": "😀",
        "codepoints": "1F600",
        "shortcode": ":grinning_face:",
        "names": {
            "en": "grinning face"
        },
        "keywords": {
            "en": ["grinning", "face"]
        },
        "category": "Smileys & Emotion",
        "favorite": false
    }
    """
    emojis = []
    current_group = "Other"

    for line in emoji_test_text.splitlines():
        raw = line
        line = line.strip()

        # Unicode groups / categories
        if line.startswith("# group:"):
            current_group = line.split("group:", 1)[1].strip()
            continue

        # ignore comments and empty lines
        if not line or line.startswith("#"):
            continue

        # Typical format:
        # 1F600                                      ; fully-qualified     # 😀 grinning face
        if ";" not in line or "#" not in line:
            continue

        try:
            codepoints_part, rest = line.split(";", 1)
            status_part, comment_part = rest.split("#", 1)
        except ValueError:
            continue

        status = status_part.strip()
        if status != "fully-qualified":
            # ignore non fully-qualified variants
            continue

        comment_part = comment_part.strip()
        # comment_part is like: "😀 grinning face"
        parts = comment_part.split()
        if len(parts) < 2:
            continue

        char = parts[0]
        name = " ".join(parts[1:]).lower()  # official English name in lowercase

        # shortcode: based on the official name
        shortcode = ":" + re.sub(r"[^a-z0-9_]+", "_", name).strip("_") + ":"

        # keywords: split English name into words
        keywords_en = list({w for w in re.split(r"[^a-z0-9]+", name) if w})

        codepoints = codepoints_part.strip()
        item = {
            "char": char,
            "codepoints": codepoints,
            "shortcode": shortcode,
            "names": {"en": name},
            "keywords": {"en": keywords_en},
            "category": current_group,
            "favorite": False,
        }
        emojis.append(item)

    # Apply local translation overrides
    by_sc = translations.get("by_shortcode", {})
    by_ch = translations.get("by_char", {})

    for item in emojis:
        sc = item.get("shortcode")
        ch = item.get("char")

        if sc in by_sc:
            item = apply_overrides(item, by_sc[sc])
        if ch in by_ch:
            item = apply_overrides(item, by_ch[ch])

    return emojis


def main():
    # 1) Try local file first
    txt = load_local_emoji_test()
    if txt is None:
        # 2) Download if not present
        txt = download_emoji_test()
        if txt is None:
            print("ERROR: Could not obtain emoji-test.txt (neither local nor remote).")
            return
        # Save a local copy for next runs
        save_local_emoji_test(txt)

    translations = load_translations()
    db = build_emoji_db(txt, translations)

    output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), OUTPUT_FILE)

    print(f"Found {len(db)} emoji. Writing to {output_path} ...")
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(db, f, ensure_ascii=False, indent=2)

    print("Done! You can now use emoji_data.json with GeppEmoji.")


if __name__ == "__main__":
    main()
