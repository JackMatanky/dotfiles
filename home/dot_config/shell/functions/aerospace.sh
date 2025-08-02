#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/apps/aerospace.sh
# Dependencies: aerospace, sketchybar (macOS only)
# Description: Aerospace window tiling manager
# -----------------------------------------------------------------------------

if [ -n "${BASH_VERSION-}" ]; then
    set -euo pipefail
    IFS=$'\n\t'
fi

# Only load on macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    return 0
fi

# ------------------------------------------------------------ #
#                         Aerospace                           #
# ------------------------------------------------------------ #

#######################################
# as: Wrapper for aerospace commands with fuzzy window selection
#
# Provides convenient shortcuts for common aerospace operations,
# including an interactive window selector using fzf.
#
# Globals:
#   None
# Arguments:
#   $1 - Command: load, debug, monitor, app, window
# Outputs:
#   Command output or help text
# Returns:
#   Exit status of aerospace command
#######################################
as() {
    case "$1" in
    load)
        aerospace reload-config
        ;;
    debug)
        aerospace debug-windows
        ;;
    monitor)
        aerospace list-monitors
        ;;
    app)
        aerospace list-apps
        ;;
    window)
        # fuzzy-select window to focus
        aerospace list-windows --all |
            fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort' |
            xargs -r aerospace focus --window-id
        ;;
    *)
        cat <<-EOF
Usage: as <command>
Available commands: load, debug, monitor, app, window
EOF
        ;;
    esac
}
