#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/lib/editor_helpers.sh
# Dependencies: User's preferred editor ($EDITOR, $VISUAL)
# Description: Editor operation helpers as private functions.
#              These are prefixed with `__` and are not meant for direct use.
# -----------------------------------------------------------------------------

#######################################
# Open a file or directory in the user's preferred editor.
#
# Selection order: $VISUAL (GUI editors) → $EDITOR → nvim → vim.
# Falls back to error if none found.
# Globals:
#   VISUAL
#   EDITOR
# Arguments:
#   $1 - File or directory path to open.
# Outputs:
#   Opens file/directory in chosen editor, or error to stderr if not possible.
# Returns:
#   Exit status of the editor command if run.
#   1 if no editor is found or no target specified.
#######################################
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

#######################################
# Select a file with fzf and open it in the preferred editor.
#
# Uses __fzf_pick_file to select the target interactively.
# Globals:
#   None
# Arguments:
#   Any arguments are forwarded to __fzf_pick_file.
# Outputs:
#   Opens selected file in chosen editor, or nothing if cancelled.
# Returns:
#   0 if a file was selected and opened.
#   1 if selection was cancelled or opening failed.
#######################################
__fzf_pick_and_edit_file() {
    local file
    file="$(__fzf_pick_file "$@")"
    if [[ -n "$file" ]]; then
        __open_in_editor "$file"
    else
        return 1
    fi
}

#######################################
# Select a directory with fzf and open it in the preferred editor.
#
# Uses __fzf_pick_dir to select the target interactively.
# Globals:
#   None
# Arguments:
#   Any arguments are forwarded to __fzf_pick_dir.
# Outputs:
#   Opens selected directory in chosen editor, or nothing if cancelled.
# Returns:
#   0 if a directory was selected and opened.
#   1 if selection was cancelled or opening failed.
#######################################
__fzf_pick_and_edit_dir() {
    local dir
    dir="$(__fzf_pick_dir "$@")"
    if [[ -n "$dir" ]]; then
        __open_in_editor "$dir"
    else
        return 1
    fi
}
