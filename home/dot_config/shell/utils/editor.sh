#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/lib/editor_helpers.sh
# Dependencies: User's preferred editor ($EDITOR, $VISUAL)
# Description: Editor operation helpers as private functions.
#              These are prefixed with `__` and are not meant for direct use.
# -----------------------------------------------------------------------------

# Open a file or directory in the user's preferred editor.
#
# Uses $VISUAL first (for GUI editors), then $EDITOR, then falls back to nvim.
#
# Globals:
#   VISUAL, EDITOR
# Arguments:
#   $1 - File or directory path to open
# Outputs:
#   Opens file/directory in editor
# Returns:
#   Exit status of the editor command.
__open_in_editor() {
    local target="$1"
    local editor

    # Determine which editor to use
    if [[ -n "${VISUAL:-}" ]] && command -v "$VISUAL" >/dev/null 2>&1; then
        editor="$VISUAL"
    elif [[ -n "${EDITOR:-}" ]] && command -v "$EDITOR" >/dev/null 2>&1; then
        editor="$EDITOR"
    elif command -v nvim >/dev/null 2>&1; then
        editor="nvim"
    elif command -v vim >/dev/null 2>&1; then
        editor="vim"
    else
        echo "Error: No editor found. Please set \$EDITOR or \$VISUAL" >&2
        return 1
    fi

    # Open the target
    if [[ -n "$target" ]]; then
        "$editor" "$target"
    else
        echo "Error: No target specified for editor" >&2
        return 1
    fi
}

# Select a file with fzf and open it in the preferred editor.
#
# Globals:
#   None (uses __fzf_pick_file and __open_in_editor)
# Arguments:
#   Any arguments are passed to __fzf_pick_file
# Outputs:
#   Opens selected file in editor
# Returns:
#   0 if successful, non-zero otherwise.
__fzf_pick_and_edit_file() {
    local file
    file="$(__fzf_pick_file "$@")"
    if [[ -n "$file" ]]; then
        __open_in_editor "$file"
    else
        return 1
    fi
}

# Select a directory with fzf and open it in the preferred editor.
#
# Globals:
#   None (uses __fzf_pick_dir and __open_in_editor)
# Arguments:
#   Any arguments are passed to __fzf_pick_dir
# Outputs:
#   Opens selected directory in editor
# Returns:
#   0 if successful, non-zero otherwise.
__fzf_pick_and_edit_dir() {
    local dir
    dir="$(__fzf_pick_dir "$@")"
    if [[ -n "$dir" ]]; then
        __open_in_editor "$dir"
    else
        return 1
    fi
}
