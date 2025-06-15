#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zed/scripts/comment-divider.sh
# Description: Generate language-aware comment dividers for main/sub headers,
#              copy result to clipboard based on OS.
# Usage: ./divider.sh --file filename.py --title "My Header" --type main
# -----------------------------------------------------------------------------

set -e

# -----------------------------
# Defaults
# -----------------------------
width=60
type="main"
file=""
title=""
comment="#"

# -----------------------------
# Language Mapping
# -----------------------------
declare -A comment_map=(
  [sh]="#"
  [bash]="#"
  [py]="#"
  [rs]="//"
  [js]="//"
  [ts]="//"
  [c]="//"
  [cpp]="//"
  [h]="//"
  [java]="//"
  [go]="//"
  [lua]="#"
  [vim]='"'
  [toml]="#"
  [yaml]="#"
  [yml]="#"
  [json]="#"
  [tex]="%"
  [md]="#"
)

# -----------------------------
# Parse Arguments
# -----------------------------
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --file|-f) file="$2"; shift ;;
    --title|-t) title="$2"; shift ;;
    --type) type="$2"; shift ;;
    --width|-w) width="$2"; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

if [[ -z "$title" ]]; then
  echo "❌ Error: --title is required."
  exit 1
fi

# -----------------------------
# Detect Comment Symbol
# -----------------------------
if [[ -n "$file" ]]; then
  ext="${file##*.}"
  comment="${comment_map[$ext]:-#}"
fi

# -----------------------------
# Style Logic
# -----------------------------
text="$title"
text_length=${#text}
padding_char="-"
[[ "$type" == "sub" ]] && padding_char="."

side_len=$(( (width - text_length - 2) / 2 ))
line=$(printf '%*s' "$width" '' | tr ' ' "$padding_char")

top="$comment $line"
middle=$(printf "%s %*s%s%*s" "$comment" "$side_len" '' "$text" "$side_len" '')
bottom="$comment $line"

output="$top"$'\n'"$middle"$'\n'"$bottom"

# -----------------------------
# Output and Clipboard Copy
# -----------------------------
echo "$output"

if command -v pbcopy >/dev/null 2>&1; then
  echo "$output" | pbcopy
  echo "[✔] Copied to clipboard via pbcopy (macOS)"
elif command -v xclip >/dev/null 2>&1; then
  echo "$output" | xclip -selection clipboard
  echo "[✔] Copied to clipboard via xclip (Linux)"
elif command -v xsel >/dev/null 2>&1; then
  echo "$output" | xsel --clipboard --input
  echo "[✔] Copied to clipboard via xsel (Linux)"
else
  echo "[!] Clipboard copy not supported on this system"
fi
