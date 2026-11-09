
#!/usr/bin/env bash

set -e

EXT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nautilus-python/extensions"

rm -f "$EXT_DIR/universal_file_creator.py"

echo "Universal File Creator has been removed."

nautilus -q >/dev/null 2>&1 || true
