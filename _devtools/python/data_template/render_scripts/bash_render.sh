#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# File: bash_render/render.sh
# Description: Bash-based project renderer using ${VAR} substitution
# -----------------------------------------------------------------------------

set -euo pipefail

# Prompt user for metadata and capture variables
read -rp "project_name: " PROJECT_NAME
read -rp "author_name: " AUTHOR_NAME
read -rp "description: " DESCRIPTION

# Enumerated project type prompt
echo "Select project_type:"
echo "1 - Data Science"
echo "2 - Data Analysis"
echo "3 - Ad Hoc"
read -rp "Choose from [1/2/3] (1): " TYPE_CHOICE
TYPE_CHOICE=${TYPE_CHOICE:-1}

case "$TYPE_CHOICE" in
  1) PROJECT_TYPE="data_science";;
  2) PROJECT_TYPE="data_analysis";;
  3) PROJECT_TYPE="ad_hoc";;
  *) PROJECT_TYPE="data_science";;
esac

# Enumerated Python version prompt
echo "Select Python version:"
echo "1 - 3.10"
echo "2 - 3.11"
echo "3 - 3.12"
read -rp "Choose from [1/2/3] (1): " PYVER_CHOICE
PYVER_CHOICE=${PYVER_CHOICE:-1}

case "$PYVER_CHOICE" in
  1) PYTHON_VERSION="3.10";;
  2) PYTHON_VERSION="3.11";;
  3) PYTHON_VERSION="3.12";;
  *) PYTHON_VERSION="3.10";;
esac

PROJECT_PATH="$PROJECT_NAME"
OUTPUT_DIR="$(pwd)/$PROJECT_PATH"
TEMPLATE_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")"/../template_files && pwd)"

if [ -d "$OUTPUT_DIR" ]; then
  echo "⚠️  Output directory '$OUTPUT_DIR' already exists. Remove it to regenerate."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Optional: conditionally include data science dependencies
if [[ "$PROJECT_TYPE" == "data_science" ]]; then
  DS_DEPENDENCIES='    "scikit-learn",\n    "xgboost",'
else
  DS_DEPENDENCIES=""
fi

# Export variables for envsubst
export PROJECT_NAME AUTHOR_NAME DESCRIPTION PROJECT_TYPE PYTHON_VERSION PROJECT_PATH DS_DEPENDENCIES

# Copy and substitute files
copy_and_render() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  # Replace variables
  rendered=$(envsubst < "$src")

  # Inject structure block if needed
  if grep -q "\${STRUCTURE_BLOCK}" "$src"; then
    snippet_file="$TEMPLATE_DIR/dir_structures/${PROJECT_TYPE}.md"
    if [[ -f "$snippet_file" ]]; then
      block="$(cat "$snippet_file")"
      rendered="${rendered//\\${STRUCTURE_BLOCK}/$block}"
    else
      rendered="${rendered//\\${STRUCTURE_BLOCK}/<!-- Structure snippet missing -->}"
    fi
  fi

  echo "$rendered" > "$dst"
  echo "✔ Created: $dst"
}

# Recursively walk template_files and render all files
while IFS= read -r -d '' file; do
  rel_path="${file#$TEMPLATE_DIR/}"
  dest_file="$OUTPUT_DIR/$rel_path"
  copy_and_render "$file" "$dest_file"
done < <(find "$TEMPLATE_DIR" -type f -print0)

echo -e "\n✅ Bash-rendered project created in: $OUTPUT_DIR\n"
