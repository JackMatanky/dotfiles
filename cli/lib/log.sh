# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/lib/log.sh
# Function: log_info, log_warn, log_error
# Usage: log_info "Message", log_warn "Warning", log_error "Failure
# Description: Color-aware logging utilities for Bash/Zsh.
# -----------------------------------------------------------------------------

# Internal helper: Print a colored log line if terminal supports it.
# Args:
#   $1 = tput color code (e.g. 2 = green)
#   $2 = log label (e.g. INFO, WARN)
#   $3 = log message
_log_with_color() {
  local color="$1"
  local label="$2"
  local message="$3"

  # Only use colors if stdout is a terminal and tput is available
  if command -v tput &>/dev/null && [[ -t 1 ]]; then
    local code reset
    code="$(tput setaf "$color")"
    reset="$(tput sgr0)"
    printf '%s[%s]%s %s\n' "$code" "$label" "$reset" "$message"
  else
    printf '[%s] %s\n' "$label" "$message"
  fi
}

# Public: Print informational message (green)
log_info() {
  _log_with_color 2 "INFO" "$1"
}

# Public: Print warning message (yellow)
log_warn() {
  _log_with_color 3 "WARN" "$1"
}

# Public: Print error message (red)
log_error() {
  _log_with_color 1 "ERROR" "$1"
}
