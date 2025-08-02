#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/shell/aliases/files.sh
# Dependencies: eza, zoxide
# Description: File management aliases and modern command replacements
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                            EZA                              #
# ------------------------------------------------------------ #
alias ll='eza --long --icons --git --all --group-directories-first'
alias l='eza --long --icons --git --all --group-directories-first'
alias lt='eza --tree --level=2 --icons --git --ignore-glob "__pycache__"'    # 2 levels
alias ltree='eza --tree --level=3 --icons --git --ignore-glob "__pycache__"' # 3 levels
alias ltree-full='eza --tree --level=5 --icons --git --ignore-glob "__pycache__"' # 5 levels

# ------------------------------------------------------------ #
#                          Zoxide                             #
# ------------------------------------------------------------ #
alias za='zoxide add'
alias zq='zoxide query'
