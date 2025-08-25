# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/lib/source_sh_files.sh
# Function: source_sh_files
# Usage: source_sh_files "$XDG_CONFIG_HOME/cli/profile"
# Description:
#   Sources all readable *.sh files from a specified directory into the
#   current shell. Files are loaded in lexicographic order, enabling
#   structured setups like 00-core.sh, 10-brew.sh, etc.
#
#   Logging is per directory:
#     Sourced: <dir>
#     except: <file_basename_1>, <file_basename_2>, ...
#   The "except" line is omitted if no files were skipped.
# -----------------------------------------------------------------------------

#######################################
# Validate that a directory exists.
# Globals:
#   None
# Arguments:
#   $1 - Directory path to validate.
# Outputs:
#   Warning message to stderr (or via log_warn) if the directory does not exist.
# Returns:
#   0 if the directory exists.
#   1 if the directory does not exist.
#######################################
__validate_dir() {
  local dir_path="$1"
  if [[ -d "$dir_path" ]]; then return 0; fi

  if typeset -f log_warn &>/dev/null; then
    log_warn "Directory not found: ${dir_path}"
  else
    echo "source_sh_files: Directory not found: ${dir_path}" >&2
  fi
  return 1
}

#######################################
# Collect top-level *.sh files from a directory and sort them lexically.
# Globals:
#   None
# Arguments:
#   $1 - Directory path to search.
# Outputs:
#   List of file paths (one per line) to stdout.
# Returns:
#   0 on success (possibly with no output if none found).
#   Non-zero on error.
#######################################
__collect_sorted_sh_files() {
  local dir_path="$1"
  find "$dir_path" -maxdepth 1 -type f -name "*.sh" 2>/dev/null | sort
}

#######################################
# Source a shell file into the current shell if it is readable.
# Globals:
#   None
# Arguments:
#   $1 - Path to the shell file.
# Outputs:
#   None
# Returns:
#   0 if file was readable and successfully sourced.
#   1 if file was not readable (not sourced).
#######################################
__source_file_if_readable() {
  local file_path="$1"
  if [[ ! -r "$file_path" ]]; then return 1; fi
  # shellcheck source=/dev/null
  source "$file_path"
  return 0
}

#######################################
# Join an array of strings into a comma-separated string.
# Globals:
#   None
# Arguments:
#   Array of strings (passed as "$@").
# Outputs:
#   Comma-separated string written to stdout.
# Returns:
#   0 always.
#######################################
__join_comma_separated() {
  local arr=("$@")
  local joined=""
  local i
  for ((i = 0; i < ${#arr[@]}; i++)); do
    if ((i == 0)); then
      joined="${arr[i]}"
    else
      joined="${joined}, ${arr[i]}"
    fi
  done
  echo "$joined"
}

#######################################
# Source all readable *.sh files from a directory in lexicographic order.
# Globals:
#   None
# Arguments:
#   $1 - Directory containing the shell fragment files.
# Outputs:
#   Per-directory log lines:
#     "Sourced: <dir>"
#     "except: <file_basename_1>, <file_basename_2>, ..." (only if any skipped)
# Returns:
#   0 if directory exists and processing completed.
#   1 if directory does not exist.
#######################################
source_sh_files() {
  local dir="$1"
  if ! __validate_dir "$dir"; then return 1; fi

  # Collect files while preserving whitespace.
  local -a files=()
  while IFS= read -r line; do
    [[ -n "$line" ]] && files+=("$line")
  done < <(__collect_sorted_sh_files "$dir")

  # Track only files that were not loaded.
  local -a not_loaded=()
  local file
  for file in "${files[@]}"; do
    if ! __source_file_if_readable "$file"; then
        not_loaded+=("$(basename "$file")");
    fi
  done

  # Build "except" list with helper (may be empty).
  local except_list
  except_list="$(__join_comma_separated "${not_loaded[@]}")"

  # Emit per-directory log (use log_info if available, else stdout).
  if typeset -f log_info &>/dev/null; then
    log_info "Sourced: ${dir}"
    [[ -n "$except_list" ]] && log_info "except: ${except_list}"
  else
    echo "Sourced: ${dir}"
    [[ -n "$except_list" ]] && echo "except: ${except_list}"
  fi

  return 0
}
