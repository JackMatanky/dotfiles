#!/usr/bin/env bash

set -e

THEME_PATH="$HOME/dotfiles/themes/colorschemes/current.sh"
EXPORT_DIR="$HOME/dotfiles/themes/colorschemes/exports"
mkdir -p "$EXPORT_DIR"

# Load theme into environment
source "$THEME_PATH"

# Create associative array of theme values
theme_keys=$(env | grep -E '^(rosewater|flamingo|pink|mauve|red|maroon|peach|yellow|green|teal|sky|sapphire|blue|lavender|text|subtext1|subtext0|overlay2|overlay1|overlay0|surface2|surface1|surface0|base|mantle|crust|bg_|fg_|cursor_|selection_|status_|inactive_|active_|accent_|md_heading_|color[0-9]+|wallpaper)=')

# JSON export
{
  echo '{'
  echo "$theme_keys" | awk -F= '{ printf "  \"%s\": \"%s\",\n", $1, $2 }' | sed '$s/,$//'
  echo '}'
} > "$EXPORT_DIR/theme.json"

# TOML export
{
  echo "$theme_keys" | awk -F= '{ printf "%s = \"%s\"\n", $1, $2 }'
} > "$EXPORT_DIR/theme.toml"

# Lua export
{
  echo "return {"
  echo "$theme_keys" | awk -F= '{ printf "  %s = \"%s\",\n", $1, $2 }' | sed '$s/,$//'
  echo "}"
} > "$EXPORT_DIR/theme.lua"

echo "Exported theme to JSON, TOML, and Lua in $EXPORT_DIR"
