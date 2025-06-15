#!/usr/bin/env bash

# Set paths
THEMES_DIR="$HOME/dotfiles/themes/colorschemes"
LINK_PATH="$THEMES_DIR/current.sh"
SELECTED="$1"

# Require theme name
if [[ -z "$SELECTED" ]]; then
  echo "Usage: $0 <theme-name>"
  echo "Available themes:"
  find "$THEMES_DIR" -maxdepth 1 -name "*.sh" -exec basename {} .sh \; | grep -v "current"
  exit 1
fi

# Full path to selected theme
TARGET="$THEMES_DIR/$SELECTED.sh"

# Validate
if [[ ! -f "$TARGET" ]]; then
  echo "Theme not found: $TARGET"
  exit 2
fi

# Update symlink
ln -sf "$TARGET" "$LINK_PATH"
echo "Selected theme: $SELECTED"

# Optionally: export theme formats
"$HOME/dotfiles/themes/scripts/export-theme.sh"
