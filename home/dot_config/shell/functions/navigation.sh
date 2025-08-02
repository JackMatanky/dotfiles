#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/navigation.sh
# Dependencies: fd, fzf, eza, bat, clipboard helpers
# Description: Navigation functions with fzf integration and clipboard support
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                          Navigation                          #
# ------------------------------------------------------------ #

#######################################
# cx: Change to a directory by name or via fzf, then list contents with eza.
#
# If no argument is provided, fzf is used to select a directory, with
# a preview of the target directory's tree. If a target is chosen, the
# shell will change into it and list its contents with the eza command.
#
# Globals:
#   None
# Arguments:
#   $1 [DIR]: Optional. Directory path or tag; if omitted, select via fzf.
# Outputs:
#   Directory listing via eza to STDOUT.
# Returns:
#   0 if navigation succeeds, non-zero on failure.
#######################################
cx() {
    local target="${1:-}"
    if [ -z "$target" ]; then
        # select a directory with fzf and preview its tree
        target="$(__fzf_pick_dir)"
    fi

    if [ -n "$target" ]; then
        # if a target is chosen, cd into it and list contents
        __cd_and_run "$target" eza -la --group-directories-first --icons
    fi
}

#######################################
# f: Fuzzy-find a file, preview with bat, and copy its path to clipboard.
# The preview window displays the contents of the selected file with bat.
# If a file is selected, its path is copied to the system clipboard.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Copies selected path to the system clipboard.
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
f() {
    local file
    # find files and preview
    file="$(__fzf_pick_file)"
    if [ -n "$file" ]; then
        # copy selection to clipboard using cross-platform helper
        printf '%s' "$file" | __copy_to_clipboard
    fi
}

#######################################
# rgf: Hybrid fd + ripgrep fuzzy file finder with bat preview.
#
# This function combines the best of both worlds from fd and rg:
#   1. fd: fast file discovery with fuzzy matching
#   2. rg: ability to search file contents with ripgrep
# The preview window displays the contents of the selected file with bat.
#
# Globals:
#   None
# Arguments:
#   $@ [QUERY...] - Optional query string to pre-populate fzf.
# Outputs:
#   Displays search results with preview to STDOUT.
# Returns:
#   Exit code of fzf.
#######################################
rgf() (
    local reload_cmd
    # define reload on query change: ripgrep or no-op, split for readability
    reload_cmd=$'reload:rg --column --line-number \
                --no-heading --color=always \
                --smart-case {q} || :'
    # initial file list
    eval 'fd --type file --hidden --follow --exclude .git' |
        fzf --ansi --multi --preview 'bat --style=full --color=always {} || cat {}' \
            --bind "$reload_cmd" \
            --delimiter : \
            --preview-window 'right:60%' \
            --query "$*"
)
