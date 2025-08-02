#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/stow_aliases.sh
# Description: Shortcuts for GNU Stow on ~/dotfiles
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail

    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                           GNU Stow                           #
# ------------------------------------------------------------ #

# ------------------------- Stow All ------------------------- #
# Symlink every package in ~/dotfiles into $HOME.
#
# Usage:
#   stow_all
stow_all() {
    # run in subshell so cwd is not changed
    (cd "$HOME/dotfiles" && stow .)
    #   cd "$HOME/dotfiles" || return
    #   stow .
}
alias stow-all='stow_all'


# ------------------------ Unstow All ------------------------ #
# Remove every symlink previously created from ~/dotfiles.
#
# Usage:
#   unstow_all
unstow_all() {
    cd "$HOME/dotfiles" || return
    stow -D .
}
alias unstow-all='unstow_all'


# ------------------------ Restow All ------------------------ #
# Reinstall all symlinks: first remove, then create.
#
# Usage:
#   restow_all
restow_all() {
    cd "$HOME/dotfiles" || return
    stow -R .
}
alias restow-all='restow_all'


# ------------------ Single-Package Aliases ------------------ #
# Remove links for a single package.
alias unstow='stow -D'
# Reinstall links for a single package.
alias restow='stow -R'
