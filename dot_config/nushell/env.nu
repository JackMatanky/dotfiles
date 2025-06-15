#------------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/env.nu
# Docs: https://www.nushell.sh/book/nu_as_a_shell.html
# Acknowledgments: Omer Hammerman (omerxx)
#                  https://github.com/omerxx/dotfiles/blob/master/nushell/env.nu
#------------------------------------------------------------------------------

# -------------------- OS Detection -------------------- #
let OS = (uname | get operating-system)

# ------------------ XDG Base Directory ------------------ #
$env.XDG_CONFIG_HOME = ($env.HOME | path join '.config')
$env.XDG_CACHE_HOME = ($env.HOME | path join '.cache')
$env.XDG_DATA_HOME = ($env.HOME | path join '.local/share')

# -------------- Git Global Config Location -------------- #
$env.GIT_CONFIG_GLOBAL = ($env.XDG_CONFIG_HOME | path join 'git/config')

# ----------------- Cargo Home Directory ----------------- #
$env.CARGO_HOME = ($env.HOME | path join '.cargo')

# Load OpenAI API Key from macOS Keychain (Best Placement)
# if ($OS == "Darwin") {
#     $env.OPENAI_API_KEY = (security find-generic-password -s "openai_api_key" -a $env.USER -w | str trim)
# }

# -------------------------------------------------------- #
#                 Nushell Environment Setup                #
# -------------------------------------------------------- #

# ------------------- Config Directory ------------------- #
# Default: $nu.default-config-dir == $XDG_CONFIG_HOME/nushell
$env.NU_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'nushell')

# ------------ Script and Completion Libraries ----------- #
# Script Default: $nu.default-config-dir/scripts
# Completion Default: $nu.data-dir/completions
$env.NU_LIB_DIRS = [
    ($env.NU_CONFIG_DIR | path join 'scripts')
    ($env.NU_CONFIG_DIR | path join 'completions')
]

# ------------------- Plugin Directory ------------------- #
# Default: $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($env.NU_CONFIG_DIR | path join 'plugins')
]


# -------------------------------------------------------- #
#              Homebrew Installation Directory             #
# -------------------------------------------------------- #
# Darwin = "/opt/homebrew"
# Linux = "/home/linuxbrew/.linuxbrew"
# Default fallback to empty string if OS is unknown
$env.HOMEBREW = (match $OS {
    "Darwin" => "/opt/homebrew"
    "Linux" =>  (brew --prefix | str trim)
    _ => ""
})

# ------------------ Homebrew Base Paths ----------------- #
$env.BREW_OPT_DIR = ($env.HOMEBREW? | default "" | path join 'opt')
$env.BREW_BIN_DIR = ($env.HOMEBREW? | default "" | path join 'bin')
$env.BREW_SBIN_DIR = ($env.HOMEBREW? | default "" | path join 'sbin')
$env.BREW_LIB_DIR = ($env.HOMEBREW? | default "" | path join 'lib')
$env.BREW_INCLUDE_DIR = ($env.HOMEBREW? | default "" | path join 'include')

# --------- Build Flags for Brew-Linked Libraries -------- #
# Help C extension modules (e.g., pygraphviz) locate
# Brew-installed headers and libraries
$env.CFLAGS = ['-I', $env.BREW_INCLUDE_DIR] | str join (char space)
$env.LDFLAGS = ['-L', $env.BREW_LIB_DIR] | str join (char space)


# -------------------------------------------------------- #
#                       Prompt Setup                       #
# -------------------------------------------------------- #
def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $'($separator_color)(char path_sep)($path_color)'
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
$env.PROMPT_INDICATOR = {|| '> ' }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ': ' }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| '> ' }
$env.PROMPT_MULTILINE_INDICATOR = {|| '::: ' }

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

# -------------------------------------------------------- #
#             Environment Variable Conversions             #
# -------------------------------------------------------- #
# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    'PATH': {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    'Path': {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}


# -------------------------------------------------------- #
#                 Dynamic PATH Declaration                 #
# -------------------------------------------------------- #
# To add entries to PATH (on Windows you might use Path),
# you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# An alternate way to add entries to $env.PATH is to use the custom
# command `path add` which is built into the nushell stdlib:
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# $env.PATH = ($env.PATH | uniq)

let base_paths = [
  '/bin'
  '/usr/bin'
  '/usr/local/bin'
  '/sbin'
  '/usr/sbin'
]

let user_paths = [
  ($env.HOME | path join '.local' 'bin')
  ($env.CARGO_HOME | path join 'bin')
]

let nixos_paths = if ($OS == 'Linux' and ('/run/current-system/sw/bin' | path exists)) {
  ['/run/current-system/sw/bin']
} else {
  []
}

if $OS == "Darwin" {
    let brew_bin_paths = [
        $env.BREW_BIN_DIR
        $env.BREW_SBIN_DIR
        ($env.BREW_OPT_DIR | path join "openjdk" "bin")
        ($env.BREW_BIN_DIR | path join "nvim")
        ($env.BREW_BIN_DIR | path join "ghostty")
        "/Applications/Ghostty.app/Contents/MacOS/ghostty"
    ]
}

$env.PATH = (
  $env.PATH
  | split row (char esep)
  | append /bin
  | append /usr/bin
  | append /usr/local/bin
  | append /sbin
  | append /usr/sbin
  | append ($env.HOME | path join '.local' 'bin')
  | append ($env.CARGO_HOME | path join 'bin')
)


if ($OS == 'Darwin') {
    $env.HOMEBREW_RUBY = ($env.BREW_OPT_DIR | path join 'ruby' 'bin')
    if ($env.HOMEBREW_RUBY | is-not-empty) {
        $env.PATH = (
          $env.PATH
          | split row (char esep)
          | prepend ($env.BREW_OPT_DIR | path join 'ruby' 'gems' '3.4.0' 'bin')
          | prepend $env.HOMEBREW_RUBY
        )
    }

    $env.PATH = (
      $env.PATH
        | split row (char esep)
        | append ($env.HOMEBREW | path join 'bin')
        | append ($env.HOMEBREW | path join 'sbin')
        | append ($env.BREW_OPT_DIR | path join 'openjdk' 'bin')
        | append ($env.BREW_BIN_DIR | path join 'ghostty')
        | append ($env.BREW_BIN_DIR | path join 'nvim')
        | append /Applications/Ghostty.app/Contents/MacOS/ghostty
    )
}

if ($OS == 'Linux') {
    $env.PATH = ($env.PATH | append /run/current-system/sw/bin)
}

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# -------------------------------------------------------- #
#          Programming Language Environment Setup          #
# -------------------------------------------------------- #

# ------------------- Pyenv Integration ------------------ #
if (which pyenv | is-not-empty) {
    # Set pyenv root and paths
    $env.PYENV_ROOT = ($env.HOME | path join '.pyenv')
    $env.PYENV_BIN = ($env.PYENV_ROOT | path join 'bin')
    $env.PYENV_SHIMS = ($env.PYENV_ROOT | path join 'shims')
    $env.PATH = (
        $env.PATH
        | split row (char esep)
        | append $env.PYENV_BIN
        | append $env.PYENV_SHIMS
    )

    # # >>> Pyenv shell integration (CRITICAL for pyenv shell/local/global) <<<
    # let pyenv_hook = (pyenv init --path | complete)
    # if ($pyenv_hook.exit_code == 0) {
    #     eval $pyenv_hook.stdout
    # }

    # Load pyenv-virtualenv if available
    if (which pyenv-virtualenv | is-not-empty) {
        $env.PYENV_VIRTUALENV = ($env.PYENV_ROOT | path join 'plugins' 'pyenv-virtualenv' 'bin')
        $env.PATH = ($env.PATH | append $env.PYENV_VIRTUALENV)
    }

    # Optional: Manually activate Neovim virtual environment if available
    $env.NEOVIM_VENV = ($env.PYENV_ROOT | path join 'versions' 'neovim')
    if ($env.NEOVIM_VENV | path exists) {
        $env.PATH = ($env.NEOVIM_VENV | path join 'bin' | prepend $env.PATH)
    }

    # Optional: Manually activate Zed virtual environment if available
    $env.ZED_VENV = ($env.PYENV_ROOT | path join 'versions' 'zed')
    if ($env.ZED_VENV | path exists) {
        $env.PATH = ($env.ZED_VENV | path join 'bin' | prepend $env.PATH)
    }
}

# Rust
# rustup does not support Nushell completions:
# https://rust-lang.github.io/rustup/installation/index.html#enable-tab-completion
# if (which rustup | is-not-empty) {
#     rustup completions nushell | save --force ~/.cache/rustup.nu
# }

# ------------------------- Java ------------------------- #
if (which java | is-not-empty) {
    $env.JAVA_HOME = if ($OS == 'Darwin') {
        '/usr/libexec/java_home -v 23'
    } else {
        '/usr/lib/jvm/default-java'
    }
}

# -------------------------------------------------------- #
#                  Tooling & Integrations                  #
# -------------------------------------------------------- #

# -------------------- Starship Prompt ------------------- #
# Docs: https://starship.rs/config/
# Nushell Guide: https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
if (which starship | is-not-empty) {
    let init_file = ($env.XDG_CACHE_HOME | path join 'starship' 'init.nu')
    # Ensure the parent directory exists
    mkdir ($init_file | path dirname)
    # Only generate init.nu if parent directory does not exist
    if not ($init_file | path exists) {
        starship init nu | save --force $init_file
    }
    $env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join 'starship' 'starship.toml')
}

# --------------- Carapace Shell Completion -------------- #
# Docs: https://carapace.sh
if (which carapace | is-not-empty) {
    mkdir ~/.cache/carapace
    carapace _carapace nushell
      | str replace "default $carapace_completer completer" "default { $carapace_completer } completer"
      | save --force ~/.cache/carapace/init.nu
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
}

# ------------------------ Zoxide ------------------------ #
# Docs: https://github.com/ajeetdsouza/zoxide
if (which zoxide | is-not-empty) {
    zoxide init nushell | save --force ~/.zoxide.nu
}

# ------------------ Atuin Shell History ----------------- #
# Docs: https://docs.atuin.sh
if (which atuin | is-not-empty) {
    let init_file = ($env.XDG_CACHE_HOME | path join 'atuin' 'init.nu')
    mkdir ($init_file | path dirname)
    if not ($init_file | path exists) {
        atuin init nu | save --force $init_file
    }
}

# ------------------ Tmux Plugin Manager ----------------- #
# Used by TPM to avoid polluting tracked dotfiles
$env.TMUX_PLUGIN_MANAGER_PATH = ($env.XDG_DATA_HOME | path join 'tmux' 'plugins')

# ------------- Zellij: Terminal Multiplexer ------------- #
# Docs: https://zellij.dev/documentation/
$env.ZELLIJ_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'zellij')
$env.ZELLIJ_LAYOUT_DIR = ($env.ZELLIJ_CONFIG_DIR | path join 'layouts')
$env.ZELLIJ_THEME_DIR = ($env.ZELLIJ_CONFIG_DIR | path join 'themes')

# -------------------------------------------------------- #
#               SSH Configuration & Keychain               #
# -------------------------------------------------------- #

# -------------------------- SSH ------------------------- #
$env.SSH_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join 'ssh')
$env.SSH_CONFIG_FILE = ($env.SSH_CONFIG_DIR | path join 'ssh-config')
$env.SSH_KEY_PATH = ($env.HOME | path join '.ssh' 'id_ed25519')

# ----------------------- Keychain ----------------------- #
# Run keychain to load the SSH key and environment variables
keychain --eval --quiet $env.SSH_KEY_PATH
    | lines
    | where not ($it | is-empty)
    | parse "{k}={v}; export {k2};"
    | select k v
    | transpose --header-row
    | into record
    | load-env

# Export SSH_AUTH_SOCK to launchctl for GUI apps like VS Code
if ($OS == "Darwin" and $env.SSH_AUTH_SOCK != null) {
    ^launchctl setenv SSH_AUTH_SOCK $env.SSH_AUTH_SOCK
}

# -------------------------------------------------------- #
#                         Defaults                         #
# -------------------------------------------------------- #
$env.EDITOR = 'nvim'        # NeoVim, 'hx' Helix
$env.VISUAL = 'zed'         # Zed
$env.TERMINAL = 'ghostty'   # Ghostty  "/Applications/Ghostty.app/Contents/MacOS/ghostty"
$env.FILE_PICKER = 'yazi'   # Yazi

# Filter out duplicate paths
$env.PATH = ($env.PATH | uniq)

# Optional: Keep Last Exit Code Variable for prompt display
$env.LAST_EXIT_CODE = 0
