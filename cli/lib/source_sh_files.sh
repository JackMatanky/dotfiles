# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/cli/lib/source_sh_files.sh
# Function: source_sh_files
# Usage: source_sh_files "$XDG_CONFIG_HOME/cli"
# Description: Source all readable *.sh files in a directory. Intended for modular
#              shell setups to load aliases, functions, and other sourced logic.
#              Optionally logs each file sourced, if log_info is defined.
# -----------------------------------------------------------------------------

source_sh_files() {
  # The target directory to search for .sh files
  local dir="$1"

  # Proceed only if the given directory exists
  if [[ -d "$dir" ]]; then

    # Iterate over each *.sh file in the directory
    for file in "$dir"/*.sh; do

      # Skip the file if it is not readable (e.g., permissions issue or
      # nonexistent)
      [[ -r "$file" ]] || continue

      # Source the file into the current shell context
      # Suppress ShellCheck warning about dynamic paths (SC1090)
      # shellcheck source=/dev/null
      source "$file"

      # Optionally log if log_info is defined
      if declare -F log_info &>/dev/null; then
        log_info "Sourced: $file"
      fi
    done
  fi
}
