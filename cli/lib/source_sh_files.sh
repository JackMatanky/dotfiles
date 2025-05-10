# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/lib/source_sh_files.sh
# Function: source_sh_files
# Usage: source_sh_files "$XDG_CONFIG_HOME/cli/env"
# Description: Sources all readable *.sh files in a directory into the current
#              shell. Files are loaded in lexicographic order, enabling controlled
#              sequencing via filename prefixes (e.g., 00-core.sh, 10-brew.sh).
#
#              Designed for modular shell setups. Also logs each sourced file if
#              a `log_info` function is defined in the current shell context.
# -----------------------------------------------------------------------------


source_sh_files() {
    # The target directory to search for .sh files
    local dir="$1"

    # -------------- Ensure Directory Existence -------------- #
    # If the directory is missing, emit a warning using `log_warn` if available,
    # otherwise fall back to stderr with `echo`. This prevents silent failures.
    if [[ ! -d "$dir" ]]; then
        if declare -F log_warn &>/dev/null; then
            log_warn "Directory not found: $dir"
        else
            echo "source_sh_files: Directory not found: $dir" >&2
        fi
        return
    fi

    # -------------------- Sort .sh Files -------------------- #
    # Get a sorted list of *.sh files (non-recursive)
    # `find ... | sort` ensures lexicographic load order (e.g., 00-core.sh first)
    local file_list
    file_list="$(find "$dir" -maxdepth 1 -type f -name "*.sh" | sort)" || true

    # Convert newline-separated string to array (Bash + Zsh compatible)
    # IFS=$'\n' → split only on newline, preserving spaces in paths
    # Uses () instead of read -a for cross-shell portability
    IFS=$'\n'
    files=($file_list)
    unset IFS

    # --------- Source Readable Files And Log Actions -------- #
    # Use `declare -F log_info` to check for presence of the logging function
    # Suppress ShellCheck dynamic sourcing warning

    # Iterate over each *.sh file in the directory
    for file in "${files[@]}"; do

        # Skip the file if it is not readable (e.g., permissions issue or
        # nonexistent)
        echo ">> Checking: $file"
        [[ -r "$file" ]] || continue

        # Source the file into the current shell context
        # shellcheck source=/dev/null
        source "$file"

        # Optionally log if log_info is defined
        if declare -F log_info &>/dev/null; then
            log_info "Sourced: $file"
        fi
    done
}
