# shellcheck shell=bash
# --------------------------------------------------------
# Filename: ~/.config/cli/lib/load_core.sh
# Function: Initializes log_info, log_warn, log_error, source_sh_files
# Usage: source "$XDG_CONFIG_HOME/cli/lib/load_core.sh"
# Description: Load core shell support modules such as logging
#              and batch sourcing of CLI shell files.
# --------------------------------------------------------

# Determine library directory path (fallback to ~/.config)
CLI_LIB_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli/lib"
CLI_LOGGER="$CLI_LIB_DIR/log.sh"
CLI_SOURCER="$CLI_LIB_DIR/source_sh_files.sh"

# Load logging functions (log_info, log_warn, log_error)
# shellcheck source=/dev/null
[[ -f "$CLI_LOGGER" ]] && source "$CLI_LOGGER"

# Load the batch sourcing utility (source_sh_files)
# shellcheck source=/dev/null
[[ -f "$CLI_SOURCER" ]] && source "$CLI_SOURCER"
