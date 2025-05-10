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
#   Designed for modular shell setups (Bash and Zsh compatible).
#   Logs each sourced file if a `log_info` function is defined.
# -----------------------------------------------------------------------------

source_sh_files() {
    # Target directory to source from
    local dir="$1"

    # ---------------- Ensure Directory Exists ---------------- #
    # If not found, log a warning (if available) or fallback to stderr
    if [[ ! -d "$dir" ]]; then
        if typeset -f log_warn &>/dev/null; then
            log_warn "Directory not found: $dir"
        else
            echo "source_sh_files: Directory not found: $dir" >&2
        fi
        return
    fi

    # ---------------- Collect and Sort Files ----------------- #
    # Use find to locate *.sh files at top level and sort them lexically.
    # This approach supports load ordering via filename prefixes.
    # IFS=$'\n' ensures file paths with spaces are preserved during word splitting.
    IFS=$'\n'
    files=($(find "$dir" \
        -maxdepth 1 \
        -type f \
        -name "*.sh" | sort))
    unset IFS

    # ----------- Source Each File With Optional Logging ----------- #
    for file in "${files[@]}"; do

        # Warn if file is unreadable instead of failing silently
        if [[ ! -r "$file" ]]; then
            if typeset -f log_warn &>/dev/null; then
                log_warn "Skipping unreadable file: $file"
            else
                echo "[WARN] Skipping unreadable file: $file" >&2
            fi
            continue
        fi

        # Source file into current shell (e.g., sets env vars, functions, etc.)
        # shellcheck source=/dev/null
        source "$file"

        # Log successful sourcing if `log_info` is defined
        if typeset -f log_info &>/dev/null; then
            log_info "Sourced: $file"
        fi
    done
}
