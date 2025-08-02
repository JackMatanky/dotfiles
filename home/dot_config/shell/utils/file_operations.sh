#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/utils/file_operations.sh
# Dependencies: fd, fzf, bat, eza
# Description: Private helper functions for file operations
# -----------------------------------------------------------------------------

#######################################
# __select_files_for_move: Select multiple files using fzf with bat preview
#
# Globals:
#   None
# Arguments:
#   $1 - Source directory (defaults to current directory)
# Outputs:
#   Writes selected file paths to stdout (one per line)
# Returns:
#   0 if files selected, non-zero otherwise
#######################################
__select_files_for_move() {
    local source_dir="${1:-.}"
    
    fd --type f . "$source_dir" | fzf --multi \
        --prompt="Select file(s) to move: " \
        --preview="bat --style=plain --color=always --line-range :40 {}"
}

#######################################
# __select_target_directory: Select a target directory using fzf with eza preview
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes selected directory path to stdout
# Returns:
#   0 if directory selected, non-zero otherwise
#######################################
__select_target_directory() {
    fd --type d | fzf \
        --prompt="Select target directory: " \
        --preview="eza --tree --level=2 --color=always {} || ls {}"
}

#######################################
# __move_file_with_options: Move a file with dry-run and confirmation support
#
# Globals:
#   None
# Arguments:
#   $1 - Source file path
#   $2 - Target directory path
#   $3 - Dry run flag (true/false)
#   $4 - Confirm flag (true/false)
# Outputs:
#   Status messages to stdout
# Returns:
#   0 if successful, non-zero otherwise
#######################################
__move_file_with_options() {
    local file="$1"
    local target_dir="$2"
    local dry_run="$3"
    local confirm="$4"
    
    if [[ "$dry_run" == true ]]; then
        echo "Would move: $file -> $target_dir/"
        return 0
    fi
    
    if [[ "$confirm" == true ]]; then
        echo -n "Move $file to $target_dir? [y/N] "
        read -r response
        case "$response" in
            [yY]|[yY][eE][sS])
                mv "$file" "$target_dir/" && echo "Moved: $file"
                ;;
            *)
                echo "Skipped: $file"
                ;;
        esac
    else
        mv "$file" "$target_dir/" && echo "Moved: $file"
    fi
}
