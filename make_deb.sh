#!/usr/bin/env bash
set -e

APP_NAME="geppemoji"
VERSION="1.0.0-1"
PKG_NAME="${APP_NAME}_${VERSION}_all"

echo "=============================="
echo "  Building ${PKG_NAME}.deb"
echo "=============================="

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="${ROOT_DIR}/build_deb"
PKG_DIR="${BUILD_ROOT}/${PKG_NAME}"

# Pulisci build precedente
rm -rf "${BUILD_ROOT}"
mkdir -p "${PKG_DIR}/DEBIAN"
mkdir -p "${PKG_DIR}/usr/share/${APP_NAME}"
mkdir -p "${PKG_DIR}/usr/share/applications"
mkdir -p "${PKG_DIR}/usr/bin"

echo "Copying app files into package tree ..."
rsync -a \
  --exclude ".git" \
  --exclude "__pycache__" \
  --exclude ".venv" \
  --exclude "build_deb" \
  "${ROOT_DIR}/" "${PKG_DIR}/usr/share/${APP_NAME}/"

# ---- CONTROL file ----
CONTROL_FILE="${PKG_DIR}/DEBIAN/control"
cat > "${CONTROL_FILE}" <<EOF
Package: ${APP_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Depends: python3 (>= 3.10), python3-gi, python3-gi-cairo, gir1.2-gtk-3.0, xdotool
Recommends: fonts-noto-color-emoji
Maintainer: Francesco Bianchi <info@bybias.com>
Description: Small desktop emoji picker written in Python + GTK3
 A lightweight emoji picker for Linux desktops, written in Python and GTK3.
EOF

echo "Created control file:"
cat "${CONTROL_FILE}"
echo

# ---- /usr/bin launcher ----
LAUNCHER="${PKG_DIR}/usr/bin/${APP_NAME}"
cat > "${LAUNCHER}" <<'EOF'
#!/bin/sh
exec python3 /usr/share/geppemoji/geppemoji.py "$@"
EOF
chmod +x "${LAUNCHER}"

# ---- .desktop file ----
DESKTOP_FILE="${PKG_DIR}/usr/share/applications/geppemoji.desktop"
cat > "${DESKTOP_FILE}" <<EOF
[Desktop Entry]
Type=Application
Name=GeppEmoji
Comment=Small desktop emoji picker written in Python + GTK3
Exec=${APP_NAME}
Icon=/usr/share/${APP_NAME}/geppemoji.png
Terminal=false
Categories=Utility;GTK;Graphics;
StartupNotify=false
EOF

echo "Building .deb package ..."
mkdir -p "${BUILD_ROOT}"
dpkg-deb --build "${PKG_DIR}"

echo
echo "Done!"
echo "You should find:"
echo "  ${BUILD_ROOT}/${PKG_NAME}.deb"
echo
echo "To install it (as root):"
echo "  sudo dpkg -i ${PKG_NAME}.deb"
echo
echo "If some dependencies are missing, you can fix them with:"
echo "  sudo apt --fix-broken install"

