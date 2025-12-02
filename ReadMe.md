# GeppEmoji

Another small **Desktop Emoji Picker** written in Python + GTK3

![Python](https://img.shields.io/badge/python-3.10%2B-blue)  ![GTK](https://img.shields.io/badge/GTK-3-lightgrey)  ![Platform](https://img.shields.io/badge/platform-Linux-success)  ![Project Status](https://img.shields.io/badge/status-active-brightgreen)  ![License](https://img.shields.io/badge/license-MIT-green)  ![GitHub stars](https://img.shields.io/github/stars/FranzBias/GeppEmoji)

GeppEmoji is a small **desktop emoji picker** written in Python + GTK3,  
designed to work smoothly on Linux (Cinnamon, GNOME, etc.) and to integrate naturally  
with your workflow through a global keyboard shortcut.

The idea is simple:

> **Open** GeppEmoji
> **pick** one or more emoji
> and it **automatically pastes** them into the window you were using before.

![Main window – “People & Body” category](assets/People&Body.png)

There are other excellent apps that do practically the same job, such as [Smile](https://github.com/mijorus/smile) and [Emote](https://github.com/tom-james-watson/Emote).
But I found that something was always missing:
either no auto-paste (because I don't use GNOME 🙅‍♂️),
or no search in my language,
or no way to edit search keywords...

So, with the help of my beloved AI “Geppetto”, **GeppEmoji** was born:
an emoji picker tailored to my way of working – and, I hope,
yours too.

If you find it useful, a ⭐ on the repository is always much appreciated 😊

---

## 🖼️ Screenshots:

| ------------------------------------ | --------------------------------------------------------------------- |
| **"Recent" category**                | !["Recent" category](assets/Recent.png)                               |
| **Edit keyword**                     | ![Keyword editor](assets/Edit.png)                                    |
| **Preferences**                      | ![Preferences](assets/Pref.png)                                       |
| **Shortcuts**                        | ![Shortcuts](assets/Shortcuts.png)                                    |
| **Update Emoji database**            | ![Update Emoji database](assets/Update.png)                           |

---

## Main Features

### 🔍 Smart Search
- Search by name, official keywords, or custom keywords  
- Supports multiple languages  
- Start typing → automatically searches in *All*

### 🗂️ Categories, Recents, and Favorites
- Categories, Recent, Favorites  
- Ctrl+F to add/remove favorites  

### 👆 Skin Tone Selector
- All skin‑tone variants appear as a **single** emoji  
- Selected tone is automatically applied everywhere
	![Skin-tone](assets/Skin-tone.png)

### 🧠 Custom Keywords
- Middle‑click or Shift+T opens keyword editor  
- Saved in `emoji_translations.json`  
- Supports per‑language keywords  

### 📌 Multi‑emoji Buffer
- Pick several emoji → paste them all at once  

### 🧾 Status Bar
- Shows number of visible emoji and current buffer content

### 🛠 Unicode Database Updater
- Download emoji‑test.txt → click *Run import*  
- Builds a fresh `emoji_data.json`

### 🎛 Preferences
- Light/Dark/System theme  
- Number of columns  
- Emoji font size  
- UI language  
- Backup/restore ZIP system  
- Edit config or translation files with your default text editor  

---

## Buy me a coffee ☕

If you want to support the project:

👉 **https://www.paypal.com/donate/?hosted_button_id=HUF5MYDG465RY**

![Donate QR-Code](assets/Donate%20QR-Code.png)

## Tank you 🙏

---
