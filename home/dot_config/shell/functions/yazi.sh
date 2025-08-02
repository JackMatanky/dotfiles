#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/cmd/yazi.sh
# Dependencies: yazi
# Description: Yazi file manager integration with directory tracking
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# ------------------------------------------------------------ #
#                            Yazi                             #
# ------------------------------------------------------------ #

#######################################
# yz: Launch Yazi, then cd into its last working directory
#
# Creates a temporary file to track directory changes in Yazi,
# then changes to that directory when Yazi exits.
#
# Globals:
#   PWD
# Arguments:
#   $@ - Any arguments to pass to yazi
# Outputs:
#   Changes current directory to Yazi's last location
# Returns:
#   Exit status of yazi command
#######################################
yz() {
    # create temp file for cwd tracking
    local tmp
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"

    # launch Yazi with cwd-file
    yazi --cwd-file "$tmp" "$@"

    # if cwd changed, cd into it
    if [[ -s "$tmp" ]]; then
        local cwd
        cwd="$(<"$tmp")"
        if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
            cd "$cwd"
        fi
    fi

    rm -f "$tmp"
}
