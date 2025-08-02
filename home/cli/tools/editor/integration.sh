#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/tools/editor/integration.sh
# Dependencies: fd, fzf, eza, bat, editor helpers
# Description: Editor integration functions (complex interactive functions only)
# Note: Simple editor aliases are in shell/aliases/editor.sh
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                         Editor Functions                     #
# ------------------------------------------------------------ #

#######################################
# ffv: Fuzzy-find a file and open it in preferred editor, with bat preview.
#
# Uses the user's preferred editor from $VISUAL or $EDITOR environment
# variables, falling back to nvim if neither is set.
#
# Globals:
#   VISUAL, EDITOR (via __open_in_editor)
# Arguments:
#   Any arguments are passed to __fzf_pick_file
# Outputs:
#   Opens selected file in preferred editor
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
ffv() {
    __fzf_pick_and_edit_file "$@"
}

#######################################
# fdv: Fuzzy-find a directory and open it in preferred editor, with eza preview.
#
# Uses the user's preferred editor from $VISUAL or $EDITOR environment
# variables, falling back to nvim if neither is set.
#
# Globals:
#   VISUAL, EDITOR (via __open_in_editor)
# Arguments:
#   Any arguments are passed to __fzf_pick_dir
# Outputs:
#   Opens selected directory in preferred editor
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
fdv() {
    __fzf_pick_and_edit_dir "$@"
}

#######################################
# fgv: Fuzzy-find a git repository and open it in preferred editor.
#
# Finds directories that contain .git folders and opens the selected
# repository in the user's preferred editor.
#
# Globals:
#   VISUAL, EDITOR (via __open_in_editor)
# Arguments:
#   None
# Outputs:
#   Opens selected repository in preferred editor
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
fgv() {
    local repo
    # Find git repositories (directories containing .git)
    repo=$(fd --type directory --hidden --exclude .git --exec test -d {}/.git \; --print |
        fzf --preview 'eza --tree --level=2 --color=always {}')
    
    if [[ -n "$repo" ]]; then
        __open_in_editor "$repo"
    fi
}
