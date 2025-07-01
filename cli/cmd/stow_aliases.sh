#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/cmd/stow_aliases.sh
# Description: Shortcuts for GNU Stow on ~/dotfiles
# -----------------------------------------------------------------------------

# Fail on errors, unset variables, and pipeline errors.
set -euo pipefail

# Set IFS to newline and tab to ensure safe word splitting.
IFS=$'\n\t'

# ------------------------------------------------------------ #
#                           GNU Stow                           #
# ------------------------------------------------------------ #

# ------------------------- Stow All ------------------------- #
# Symlink every package in ~/dotfiles into $HOME.
#
# Usage:
#   stow-all
stow-all() {
    # run in subshell so cwd is not changed
    (cd "$HOME/dotfiles" && stow .)
    #   cd "$HOME/dotfiles" || return
    #   stow .
}

# ------------------------ Unstow All ------------------------ #
# Remove every symlink previously created from ~/dotfiles.
#
# Usage:
#   unstow-all
unstow-all() {
    cd "$HOME/dotfiles" || return
    stow -D .
}

# ------------------------ Restow All ------------------------ #
# Reinstall all symlinks: first remove, then create.
#
# Usage:
#   restow-all
restow-all() {
    cd "$HOME/dotfiles" || return
    stow -R .
}

# ------------------ Single-Package Aliases ------------------ #
# Remove links for a single package.
alias unstow='stow -D'
# Reinstall links for a single package.
alias restow='stow -R'
