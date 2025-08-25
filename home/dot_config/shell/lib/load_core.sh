# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/lib/load_core.sh
# Function: Initializes log_info, log_warn, log_error, source_sh_files
# Usage: source "$XDG_CONFIG_HOME/shell/lib/load_core.sh"
# Description: Load core shell support modules such as logging and batch
#              sourcing of CLI shell files.
# -----------------------------------------------------------------------------

# Determine library directory paths
# Only set if not already defined to avoid readonly conflicts
: ${SHELL_DIR:="${XDG_CONFIG_HOME:-$HOME/.config}/shell"}
: ${LIB_DIR:="${SHELL_DIR}/lib"}

# Load logging functions (log_info, log_warn, log_error)
# shellcheck source=/dev/null
[[ -f "${LIB_DIR}/log.sh" ]] && source "${LIB_DIR}/log.sh"

# Load the batch sourcing utility (source_sh_files)
# shellcheck source=/dev/null
[[ -f "${LIB_DIR}/source_sh_files.sh" ]] && source "${LIB_DIR}/source_sh_files.sh"
