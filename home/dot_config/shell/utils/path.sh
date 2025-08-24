# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/utils/path.sh
# Description: Safe helpers for manipulating PATH (prepend/append without dupes).
# Notes:
#   - Works in Bash (>=4) and Zsh.
#   - Preserves PATH order: new entries are only added if not already present.
#   - Provides one primary helper (`path_update`) with clear wrappers
#     (`path_prepend`, `path_append`) for ergonomics.
# -----------------------------------------------------------------------------

#######################################
# Update PATH by prepending or appending a directory if not already present.
# Globals:
#   PATH
# Arguments:
#   $1 - Action: "prepend" or "append".
#   $2 - Directory path to add.
# Outputs:
#   None
# Returns:
#   0 if directory is added or already present.
#   1 if arguments are missing or invalid.
# Examples:
#   path_update prepend "/opt/homebrew/bin"
#   path_update append "$HOME/.local/bin"
#######################################
__path_update() {
    local action="$1"
    local dir="$2"

    # Require both action and directory
    [[ -z "$action" || -z "$dir" ]] && return 1

    # Exit early if PATH already contains the directory
    [[ ":$PATH:" == *":$dir:"* ]] && return 0

    # Prepend or append depending on action
    case "$action" in
    prepend)
        PATH="$dir:$PATH"
        ;;
    append)
        PATH="$PATH:$dir"
        ;;
    *)
        return 1 # invalid action string
        ;;
    esac

    return 0
}

#######################################
# Prepend a directory to PATH if not already present.
# Globals:
#   PATH
# Arguments:
#   $1 - Directory path to prepend.
# Outputs:
#   None
# Returns:
#   0 if directory is prepended or already present.
#   1 if argument is empty.
# Example:
#   path_prepend "/opt/homebrew/bin"
#######################################
__path_prepend() {
    path_update prepend "$1"
}

#######################################
# Append a directory to PATH if not already present.
# Globals:
#   PATH
# Arguments:
#   $1 - Directory path to append.
# Outputs:
#   None
# Returns:
#   0 if directory is appended or already present.
#   1 if argument is empty.
# Example:
#   path_append "$HOME/.local/bin"
#######################################
__path_append() {
    path_update append "$1"
}
