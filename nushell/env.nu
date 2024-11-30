# Nushell Environment Configuration
#
# This file configures environment variables, prompts, and integrations
# for Nushell, specifically tailored for NixOS.

# DEFINE PROMPTS
# The left prompt shows the current directory and admin status.
def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD                      # If relative path fails, use full path
        '' => '~'                             # If in home directory, show `~`
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    # Change colors based on admin privileges
    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })

    # Format the path segment
    let path_segment = $"($path_color)($dir)"
    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

# The right prompt shows the current time and the last exit code (if non-zero).
def create_right_prompt [] {
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X')       # Use locale-specific date and time
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi red_bold)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    # Combine last exit code and time segment
    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Configure the left and right prompts
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# Set prompt indicators
$env.PROMPT_INDICATOR = {|| "> " }                     # Standard prompt
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }         # Multiline prompt indicator

# ENVIRONMENT VARIABLE CONVERSIONS
# Defines how environment variables are handled in Nushell
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# PATH CONFIGURATION
# Add common paths used in NixOS to the PATH environment variable
use std "path add"
path add /run/current-system/sw/bin                 # System binaries for NixOS
path add /nix/var/nix/profiles/default/bin          # Nix profile binaries
path add ($env.HOME | path join ".local" "bin")     # User-specific binaries
path add ($env.CARGO_HOME | path join "bin")        # Rust's Cargo binaries

# STARSHIP PROMPT
# Initialize Starship prompt for Nushell
mkdir ~/.cache/starship                       # Ensure Starship cache directory exists
starship init nu | save --force ~/.cache/starship/init.nu
$env.STARSHIP_CONFIG = ($nu.default-config-dir | path join 'starship/starship.toml') # Starship configuration file location

# ZOXIDE
# Initialize Zoxide for faster directory navigation
zoxide init nushell | save --force ~/.zoxide.nu

# CARAPACE
# Initialize Carapace for intelligent autocompletions
mkdir ~/.cache/carapace                       # Ensure Carapace cache directory exists
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # Configure bridges for Carapace (optional)

# NIX CONFIGURATION
# Set the Nix configuration directory
$env.NIX_CONF_DIR = ($nu.default-config-dir | path join 'nix') # Directory for Nix configuration
