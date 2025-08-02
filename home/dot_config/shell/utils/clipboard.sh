#!/usr/bin/env bash
# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/lib/clipboard_helpers.sh
# Dependencies: pbcopy (macOS), xclip or wl-copy (Linux)
# Description: Cross-platform clipboard operations as private helper functions.
#              These are prefixed with `__` and are not meant for direct use.
# -----------------------------------------------------------------------------

# Copy text to system clipboard using platform-appropriate tool.
#
# Globals:
#   None
# Arguments:
#   Reads from stdin
# Outputs:
#   Copies input to system clipboard
# Returns:
#   0 if successful, non-zero otherwise.
__copy_to_clipboard() {
    if command -v pbcopy >/dev/null 2>&1; then
        # macOS
        pbcopy
    elif command -v wl-copy >/dev/null 2>&1; then
        # Wayland (Linux)
        wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        # X11 (Linux)
        xclip -selection clipboard
    else
        echo "Error: No clipboard tool found (pbcopy, wl-copy, or xclip)" >&2
        return 1
    fi
}

# Paste text from system clipboard using platform-appropriate tool.
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes clipboard contents to stdout
# Returns:
#   0 if successful, non-zero otherwise.
__paste_from_clipboard() {
    if command -v pbpaste >/dev/null 2>&1; then
        # macOS
        pbpaste
    elif command -v wl-paste >/dev/null 2>&1; then
        # Wayland (Linux)
        wl-paste
    elif command -v xclip >/dev/null 2>&1; then
        # X11 (Linux)
        xclip -selection clipboard -o
    else
        echo "Error: No clipboard tool found (pbpaste, wl-paste, or xclip)" >&2
        return 1
    fi
}
