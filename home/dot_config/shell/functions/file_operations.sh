#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/shell/functions/file_operations.sh
# Dependencies: fd, fzf, bat, eza, file operation helpers
# Description: Interactive file operation functions
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

#######################################
# mvf: Interactive helper to move one or more files to a selected directory
# using fd and fzf. Supports optional source directory filtering, bat previews,
# dry-run mode, and confirmation prompts.
#
# Globals:
#   None
# Arguments:
#   --current-dir: Use current directory as source (default)
#   --dir DIR: Use specified directory as source
#   --dry-run: Show what would be moved without actually moving
#   --confirm: Ask for confirmation before each move
# Outputs:
#   Progress and dry-run information to STDOUT.
# Returns:
#   0 if files are moved; non-zero on error or cancellation.
#######################################
mvf() {
    local dir="."
    local dry_run=false
    local confirm=false
    local arg

    # Parse flags
    while [[ $# -gt 0 ]]; do
        arg="$1"
        case "$arg" in
            --current-dir)
                dir="."
                shift
                ;;
            --dir)
                dir="$2"
                shift 2
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            --confirm)
                confirm=true
                shift
                ;;
            *)
                echo "Unknown option: $arg" >&2
                return 1
                ;;
        esac
    done

    # Select files to move using helper
    local files
    files=$(__select_files_for_move "$dir")

    if [[ -z "$files" ]]; then
        echo "No files selected."
        return 1
    fi

    # Select target directory using helper
    local target_dir
    target_dir=$(__select_target_directory)

    if [[ -z "$target_dir" ]]; then
        echo "No target directory selected."
        return 1
    fi

    # Process each selected file using helper
    while IFS= read -r file; do
        __move_file_with_options "$file" "$target_dir" "$dry_run" "$confirm"
    done <<< "$files"
}
