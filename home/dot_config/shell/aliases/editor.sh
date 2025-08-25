#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/shell/aliases/editor.sh
# Dependencies: Editor helper functions
# Description: Editor-related aliases
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                           Editor                             #
# ------------------------------------------------------------ #

# Basic editor aliases (will use $VISUAL or $EDITOR via helper)
alias v='nvim'
alias vdiff='nvim -d'  # diff mode still requires nvim specifically
