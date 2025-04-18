#------------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/env.nu
# Docs: https://www.nushell.sh/book/nu_as_a_shell.html
# Source Author: Omer Hammerman (omerxx)
# Source Link: https://github.com/omerxx/dotfiles/blob/master/nushell/env.nu
#------------------------------------------------------------------------------

# >>> XDG Base Directory <<<
$env.XDG_CONFIG_HOME = ($env.HOME | path join '.config')
$env.XDG_CACHE_HOME = ($env.HOME | path join '.cache')
$env.XDG_DATA_HOME = ($env.HOME | path join '.local/share')

# >>> Git Global Config Location <<<
$env.GIT_CONFIG_GLOBAL = ($env.XDG_CONFIG_HOME | path join 'git/config')

# >>> Cargo Home Directory <<<
$env.CARGO_HOME = ($env.HOME | path join '.cargo')

# >>> Homebrew Installation Directory <<<
$env.HOMEBREW = '/opt/homebrew'

# OS Detection
let OS = (uname | get operating-system)

# Load OpenAI API Key from macOS Keychain (Best Placement)
# if ($OS == "Darwin") {
#     $env.OPENAI_API_KEY = (security find-generic-password -s "openai_api_key" -a $env.USER -w | str trim)
# }

# ---------------------------------------------------
# >>> Prompt Setup <<<
# ---------------------------------------------------
def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# ---------------------------------------------------
# >>> Environment Variable Conversions <<<
# ---------------------------------------------------
# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
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

# Directories for scripts and plugins
# Default: $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

# Default: $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# ---------------------------------------------------
# Update PATH dynamically
# ---------------------------------------------------
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | append /bin
  | append /usr/bin
  | append /usr/local/bin
  | append /sbin
  | append /usr/sbin
  | append ($env.HOME | path join ".local" "bin")
  | append ($env.HOME | path join ".pyenv" "bin")
  | append ($env.HOME | path join ".pyenv" "shims")
  | append ($env.XDG_CONFIG_HOME | path join 'zide/bin')
  | append ($env.CARGO_HOME | path join 'bin')
)

if ($OS == "Darwin") {
    $env.PATH = (
      $env.PATH
        | split row (char esep)
        | append ($env.HOMEBREW | path join "bin")
        | append ($env.HOMEBREW | path join "sbin")
        | append ($env.HOMEBREW | path join "opt" "openjdk" "bin")
        | append ($env.HOMEBREW | path join "bin" "ghostty")
        | append ($env.HOMEBREW | path join "bin" "nvim")
        | append /Applications/Ghostty.app/Contents/MacOS/ghostty
    )
}

if ($OS == "Linux") {
    $env.PATH = ($env.PATH | append /run/current-system/sw/bin)
}

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# ---------------------------------------------------
# Programming Language Environment Setup
# ---------------------------------------------------
# pyenv
# if (which pyenv | is-not-empty) {
#    $env.PYENV_ROOT = ($env.HOME | path join ".pyenv")
#    $env.PATH = ($env.PATH | append ($env.PYENV_ROOT | path join "bin"))
#    $env.PATH = ($env.PATH | append ($env.PYENV_ROOT | path join "shims"))
#}

# pyenv
if (which pyenv | is-not-empty) {
    $env.PYENV_ROOT = ($env.HOME | path join ".pyenv")
    $env.PATH = ($env.PATH | append ($env.PYENV_ROOT | path join "bin"))
    $env.PATH = ($env.PATH | append ($env.PYENV_ROOT | path join "shims"))

    # Load pyenv-virtualenv if available
    if (which pyenv-virtualenv | is-not-empty) {
        let pyenv_virtualenv_path = ($env.PYENV_ROOT | path join "plugins/pyenv-virtualenv/bin")
        $env.PATH = ($env.PATH | append $pyenv_virtualenv_path)
    }

    # Manually activate the Neovim virtual environment in Nushell
    let venv_path = ($env.PYENV_ROOT | path join "versions/neovim")
    if ($venv_path | path exists) {
        $env.VIRTUAL_ENV = $venv_path
        $env.PATH = ($env.VIRTUAL_ENV | path join "bin" | prepend $env.PATH)
    }
}

# Rust
# rustup does not support Nushell completions:
# https://rust-lang.github.io/rustup/installation/index.html#enable-tab-completion
# if (which rustup | is-not-empty) {
#     rustup completions nushell | save --force ~/.cache/rustup.nu
# }

# Java
if (which java | is-not-empty) {
    $env.JAVA_HOME = if ($OS == "Darwin") {
        '/usr/libexec/java_home -v 23'
    } else {
        '/usr/lib/jvm/default-java'
    }
}

# ---------------------------------------------------
# Tooling & Integrations
# ---------------------------------------------------
# if (which starship | is-not-empty) {
#     mkdir ~/.cache/starship
#     starship init nu | save --force ~/.cache/starship/init.nu
#     $env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join 'starship/starship.toml')
# }

# Only proceed if starship is installed
if (which starship | is-not-empty) {
    # Path to starship's Nushell init script
    let init_file = ($env.XDG_CACHE_HOME | path join "starship/init.nu")
    # Ensure the parent directory exists
    mkdir ($init_file | path dirname)
    # Only generate init.nu if it doesn't exist
    if not ($init_file | path exists) {
        starship init nu | save --force $init_file
    }
    # Point to your Starship config file
    $env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join "starship/starship.toml")
}

if (which zoxide | is-not-empty) {
    zoxide init nushell | save --force ~/.zoxide.nu
}

if (which carapace | is-not-empty) {
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
}

# Zellij
$env.ZELLIJ_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'zellij')
$env.ZELLIJ_LAYOUT_DIR = ($env.ZELLIJ_CONFIG_DIR | path join 'layouts')
$env.ZELLIJ_THEME_DIR = ($env.ZELLIJ_CONFIG_DIR | path join 'themes')

# ZIDE
# # Source: https://github.com/josephschmitt/zide
$env.ZIDE_LAYOUT_DIR = $env.ZELLIJ_LAYOUT_DIR
$env.ZIDE_ALWAYS_NAME = "true"
$env.ZIDE_FILE_PICKER = "yazi"
$env.ZIDE_USE_YAZI_CONFIG = ($env.XDG_CONFIG_HOME | path join 'yazi')

# ---------------------------------------------------
# SSH Configuration & Keychain
# ---------------------------------------------------
# SSH
$env.SSH_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'ssh')
$env.SSH_CONFIG_FILE = ($env.SSH_CONFIG_DIR | path join 'ssh-config')
$env.SSH_KEY_PATH = ($env.HOME | path join '.ssh' 'id_ed25519')

# Run keychain to load the SSH key and environment variables
keychain --eval --quiet $env.SSH_KEY_PATH
    | lines
    | where not ($it | is-empty)
    | parse "{k}={v}; export {k2};"
    | select k v
    | transpose --header-row
    | into record
    | load-env

# if ($OS == "Darwin" or $OS == "Linux") {
#     keychain --eval --quiet $env.SSH_KEY_PATH
#         | lines
#         | where not ($it | is-empty)
#         | parse "{k}={v}; export {k2};"
#         | select k v
#         | transpose --header-row
#         | into record
#         | load-env
# }

# ---------------------------------------------------
# >>> Defaults <<<
# ---------------------------------------------------
$env.EDITOR = "nvim"        # NeoVim, 'hx' Helix
$env.VISUAL = "zed"         # Zed
$env.TERMINAL = "ghostty"   # Ghostty  "/Applications/Ghostty.app/Contents/MacOS/ghostty"
$env.FILE_PICKER = "yazi"   # Yazi

# Nushell
$env.NU_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'nushell')

# # Filter out duplicate paths
$env.PATH = ($env.PATH | uniq)

# Optional: Keep Last Exit Code Variable for prompt display
$env.LAST_EXIT_CODE = 0
