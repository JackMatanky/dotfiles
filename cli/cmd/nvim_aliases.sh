#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/nvim_aliases.sh
# Dependencies: fd, fzf, eza, bat, pbcopy (macOS), tmux, zellij, zoxide
# Description: Aliases and functions for navigation, fuzzy finding, tmux/zellij
#              sessions, and various tooling integrations.
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail

    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi


# ------------------------------------------------------------ #
#                            NeoVim                            #
# ------------------------------------------------------------ #
alias v='nvim'
alias vdiff='nvim -d'

#######################################
# ffv: Fuzzy-find a file and open it in Neovim, with bat preview.
#
# The previewer shows the contents of the file with bat if it's
# a text file, or simply cat if it's not. The result is opened
# in Neovim if a file is selected.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Opens selected file in nvim.
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
ffv() {
    local file

    # select file with fzf and preview
    file="$(__fzf_pick_file)"

    # open in Neovim if selected
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}


#######################################
# fdv: Fuzzy-find a directory and open it in Neovim, with eza preview.
#
# The previewer shows the contents of the selected directory with eza,
# with a tree view of up to 2 levels. The result is opened in Neovim
# if a directory is selected.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Opens selected directory in nvim.
# Returns:
#   0 if successful, non-zero otherwise.
#######################################
fdv() {
    local dir

    # select directory with fzf and preview
    dir="$(__fzf_pick_dir)"

    # open in Neovim if selected
    if [ -n "$dir" ]; then
        nvim "$dir"
    fi
}


#######################################
# fgv: Fuzzy-find a git repository and open it in Neovim, with eza preview.
#
# The previewer shows the contents of the selected repository with eza,
# with a tree view of up to 2 levels. The result is opened in Neovim
# if a repository is selected.
#
# Usage:
#   fgv
#######################################
fgv() {
    local repo
    # select repository with fzf and preview
    repo=$(fd --type directory --hidden --exclude .git |
        fzf --preview 'eza --tree --level=2 --color=always {}')
    # open in Neovim if selected
    [ -n "$repo" ] && nvim "$repo"
}
