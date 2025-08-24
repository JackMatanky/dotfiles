# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/ocr_aliases.sh
# Description: Aliases for OCR-related tasks
# -----------------------------------------------------------------------------

# ocrfile: OCR a single PDF (arg or fzf)
ocrfile() {
  local input="$1"
  if [ -z "$input" ]; then
    input="$(fd --type file --extension pdf | fzf)"
    [ -z "$input" ] && echo "No file selected." && return 1
  fi

  local abs_path output
  abs_path="$(realpath "$input")"
  output="${abs_path%.pdf}_ocr.pdf"

  ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_path" "$output"
}

# ocrfolder: OCR all PDFs in a folder (arg or fzf)
ocrfolder() {
  local folder="$1"
  if [ -z "$folder" ]; then
    folder="$(fd --type directory | fzf)"
    [ -z "$folder" ] && echo "No folder selected." && return 1
  fi

  local abs_path pdf output
  abs_path="$(realpath "$folder")"

  while IFS= read -r pdf; do
    local abs_pdf output
    abs_pdf="$(realpath "$pdf")"
    output="${abs_pdf%.pdf}_ocr.pdf"

    if [ -f "$output" ]; then
      echo "⚠️ Skipping (exists): $output"
      continue
    fi

    echo "OCR'ing: $abs_pdf"
    ocrmypdf --rotate-pages --deskew --output-type pdf "$abs_pdf" "$output"
  done < <(fd --type file --extension pdf "$abs_path")

  echo "✅ Batch OCR complete."
}
