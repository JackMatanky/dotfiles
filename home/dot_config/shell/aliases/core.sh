#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/core_aliases.sh
# Dependencies: Basic shell utilities
# Description: Core shell aliases and simple commands
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    # Fail on errors, unset variables, and pipeline errors.
    set -euo pipefail
    # Set IFS to newline and tab to ensure safe word splitting.
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                        Basic Aliases                        #
# ------------------------------------------------------------ #

# Clear screen
alias c='clear'

# Simple ls alternative
alias l='ls -l'

# Justfile shortcut
alias j='just'
