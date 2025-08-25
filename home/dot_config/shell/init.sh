# shellcheck shell=bash
# vim: filetype=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/init.sh
# Description: Master shell initialization file for modular CLI environment.
#              Single entry point for all shell configurations (bash/zsh).
#              Loads core libraries, environment, utilities, and tools.
# Usage: source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/init.sh"
# -----------------------------------------------------------------------------

# Guard against multiple sourcing
[[ -n "${SHELL_INIT_LOADED:-}" ]] && return 0

# Require HOME; exit with error if unset/empty
: "${HOME:?HOME must be set}"

# ------------------------------------------------------------ #
#                    Core Path Configuration                   #
# ------------------------------------------------------------ #
# Essential XDG and Shell Paths; Assign only if unset/empty
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
: "${SHELL_DIR:=${XDG_CONFIG_HOME}/shell}"
: "${LIB_DIR:=${SHELL_DIR}/lib}"

# Validate shell directory exists
if [[ ! -d "$SHELL_DIR" ]]; then
    printf 'Error: Shell directory does not exist: %s\n' "$SHELL_DIR" >&2
    return 1
fi

# ------------------------------------------------------------ #
#                     Load Core Libraries                      #
# ------------------------------------------------------------ #
# Load logging functions (log_info, log_warn, log_error)
# shellcheck source=/dev/null
[[ -f "${LIB_DIR}/log.sh" ]] && source "${LIB_DIR}/log.sh"

# Load the batch sourcing utility (source_sh_files)
# shellcheck source=/dev/null
[[ -f "${LIB_DIR}/source_sh_files.sh" ]] && source "${LIB_DIR}/source_sh_files.sh"

# Verify core functions are available
if ! command -v source_sh_files >/dev/null 2>&1; then
    printf 'Error: source_sh_files function not available\n' >&2
    return 1
fi

# ------------------------------------------------------------ #
#                    Private Helper Functions                  #
# ------------------------------------------------------------ #

# Helper function for conditional warning messages
# Provides consistent warning format with fallback for missing log functions
# Usage: _warn_if_missing "Module Type" "/path/to/directory"
# Example: _warn_if_missing "Profile" "${SHELL_DIR}/profile"
_warn_if_missing() {
    local item_type="$1"
    local item_path="$2"
    if command -v log_warn >/dev/null 2>&1; then
        log_warn "${item_type} directory not found: ${item_path}"
    else
        printf 'Warning: %s directory not found: %s\n' "$item_type" "$item_path" >&2
    fi
}

# Helper function for conditional module loading with comprehensive error handling
# Encapsulates the complete logic: directory testing → file sourcing → warning
# Usage: _try_source_module "Module Name" "/path/to/module/dir"
# 
# Behavior:
#   - If directory exists: calls source_sh_files to load all .sh files
#   - If directory missing: issues warning via _warn_if_missing
#   - If source_sh_files unavailable: returns error
# 
# Examples:
#   _try_source_module "Profile" "${SHELL_DIR}/profile"
#   _try_source_module "Utils" "${SHELL_DIR}/utils"
_try_source_module() {
    local module_name="$1"
    local module_path="$2"
    
    if [[ -d "$module_path" ]]; then
        if command -v source_sh_files >/dev/null 2>&1; then
            source_sh_files "$module_path"
        else
            printf 'Error: source_sh_files function not available for %s\n' "$module_name" >&2
            return 1
        fi
    else
        _warn_if_missing "$module_name" "$module_path"
    fi
}

# ------------------------------------------------------------ #
#                   Load Shell Modules                         #
# ------------------------------------------------------------ #
# Load modules in dependency order with error handling

# 1. Environment Variables (XDG paths, language setup, etc.)
_try_source_module "Profile" "${SHELL_DIR}/profile"

# 2. Utility Functions (navigation, clipboard, editor, etc.)
_try_source_module "Utils" "${SHELL_DIR}/utils"

# 3. Custom Functions
_try_source_module "Functions" "${SHELL_DIR}/functions"

# 4. Aliases (load last to ensure all functions are available)
_try_source_module "Aliases" "${SHELL_DIR}/aliases"

# ------------------------------------------------------------ #
#                    Initialization Complete                   #
# ------------------------------------------------------------ #
# Mark initialization as complete to prevent re-sourcing
export SHELL_INIT_LOADED=1

# Optional: Log successful initialization (only if logging is available)
if command -v log_info >/dev/null 2>&1; then
    log_info "Shell environment initialized successfully"
fi
