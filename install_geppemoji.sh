#!/usr/bin/env bash
set -e

echo "=============================="
echo "  GeppEmoji – Installer"
echo "=============================="
echo

# Directory del repo (dove sta lo script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Controllo file principali
if [[ ! -f "geppemoji.py" ]]; then
    echo "Error: geppemoji.py not found in this folder."
    echo "Please run this installer from inside the GeppEmoji repository."
    exit 1
fi

APP_DIR="$HOME/.local/share/geppemoji"
DESKTOP_FILE="$HOME/.local/share/applications/geppemoji.desktop"

echo "Install directory: $APP_DIR"
echo

mkdir -p "$APP_DIR"

echo "Copying files to $APP_DIR ..."
# Copia tutto tranne .git, __pycache__, eventuali venv
rsync -a \
  --exclude ".git" \
  --exclude "__pycache__" \
  --exclude ".venv" \
  ./ "$APP_DIR/"

cd "$APP_DIR"

# --- Controlli su Python e GTK (di sistema) ----------------

echo "Checking Python 3 ..."
if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 not found. Please install Python 3 and re-run."
    exit 1
fi

echo "Checking PyGObject / GTK (system packages) ..."
if ! python3 -c "import gi; from gi.repository import Gtk" >/dev/null 2>&1; then
    echo "Error: Python GTK bindings not available."
    echo "On Debian/Ubuntu/Mint you can install them with:"
    echo "  sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0"
    exit 1
fi

echo "Checking xdotool (optional, for auto-paste) ..."
if ! command -v xdotool >/dev/null 2>&1; then
    echo "Warning: xdotool is not installed."
    echo "Auto-paste will not work without it."
    echo "You can install it with:"
    echo "  sudo apt install xdotool"
fi

# --- Creazione venv locale con system-site-packages --------

echo
echo "Creating local Python virtual environment (.venv, with system site-packages) ..."
rm -rf .venv
python3 -m venv .venv --system-site-packages

if [[ ! -f ".venv/bin/activate" ]]; then
    echo "Error: virtualenv activation script not found."
    exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

# --- Installazione dipendenze pure-Python ------------------

if [[ -f "requirements.txt" ]]; then
    echo
    echo "Installing Python dependencies inside the venv (excluding GTK-related packages) ..."

    # Creiamo un requirements temporaneo SENZA pygobject/pycairo
    TMP_REQ="$(mktemp geppemoji_req.XXXXXX.txt)"
    grep -viE '^(pygobject|pycairo)\b' requirements.txt > "$TMP_REQ" || true

    if [[ -s "$TMP_REQ" ]]; then
        echo "Using temporary requirements file: $TMP_REQ"
        pip install --upgrade pip
        pip install -r "$TMP_REQ"
    else
        echo "No pure-Python dependencies to install from requirements.txt."
    fi

    rm -f "$TMP_REQ"
else
    echo
    echo "No requirements.txt found, skipping Python dependency installation."
fi

# --- Costruzione database emoji ----------------------------

echo
echo "Building emoji database (emoji_data.json) ..."
if python3 build_emoji_db.py; then
    echo "Emoji database built successfully."
else
    echo "Warning: build_emoji_db.py failed."
    echo "You can try running it manually later:"
    echo "  cd \"$APP_DIR\""
    echo "  source .venv/bin/activate"
    echo "  python3 build_emoji_db.py"
fi

deactivate || true

# --- Creazione launcher .desktop ---------------------------

echo
echo "Creating desktop launcher: $DESKTOP_FILE"

mkdir -p "$(dirname "$DESKTOP_FILE")"

ICON_PATH="$APP_DIR/geppemoji.png"
if [[ ! -f "$ICON_PATH" ]]; then
    echo "Note: geppemoji.png not found in $APP_DIR."
    echo "The launcher will still be created, but without a custom icon."
    ICON_PATH=""
fi

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=GeppEmoji
Comment=Small desktop emoji picker written in Python + GTK3
Exec=$APP_DIR/.venv/bin/python $APP_DIR/geppemoji.py
Icon=$ICON_PATH
Terminal=false
Categories=Utility;GTK;Graphics;
StartupNotify=false
EOF

chmod +x "$DESKTOP_FILE"

echo
echo "------------------------------"
echo "  Installation completed!"
echo "------------------------------"
echo
echo "You should now see 'GeppEmoji' in your application menu."
echo "If it doesn't appear immediately, you can log out/in or run (if available):"
echo "  update-desktop-database ~/.local/share/applications"
echo
echo "To run it manually from terminal:"
echo "  cd \"$APP_DIR\""
echo "  source .venv/bin/activate"
echo "  python3 geppemoji.py"
echo
echo "Or directly via the launcher:"
echo "  $APP_DIR/.venv/bin/python $APP_DIR/geppemoji.py"
echo
echo "Have fun with your emoji! 🎉"
