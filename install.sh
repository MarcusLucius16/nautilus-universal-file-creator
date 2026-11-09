
#!/usr/bin/env bash

set -e

echo "Universal File Creator - Installer"
echo "==================================="

# Install dependencies
if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed nautilus-python zenity

elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y python3-nautilus zenity

elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y nautilus-python zenity

elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y nautilus-python zenity

else
    echo "Unsupported package manager."
    echo "Please install nautilus-python and zenity manually."
    exit 1
fi

# Install extension
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EXT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nautilus-python/extensions"

mkdir -p "$EXT_DIR"

if [[ ! -f "$SCRIPT_DIR/universal_file_creator.py" ]]; then
    echo "Error: universal_file_creator.py not found!"
    exit 1
fi

install -m 644 "$SCRIPT_DIR/universal_file_creator.py" "$EXT_DIR/universal_file_creator.py"

echo ""
echo "Installation completed successfully!"
echo "Restart GNOME Files (Nautilus) to activate the extension."

nautilus -q >/dev/null 2>&1 || true
