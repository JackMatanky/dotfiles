# Nushell Environment Config File
#
# Tailored for macOS with enhancements for prompt and paths

# Define a custom left prompt
def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

# Define a custom right prompt
def create_right_prompt [] {
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X')
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi red_bold)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Set custom prompts
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# Environment Variable Conversions
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories for scripts and plugins
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# Update PATH dynamically
let-env PATH = ["/opt/homebrew/bin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" $env.PATH]

# Optional integrations
if (which starship | is-not-empty) {
    mkdir -p ~/.cache/starship
    starship init nu | save --force ~/.cache/starship/init.nu
    let-env STARSHIP_CONFIG = "~/.config/starship/starship.toml"
}

if (which zoxide | is-not-empty) {
    zoxide init nushell | save --force ~/.zoxide.nu
}

if (which carapace | is-not-empty) {
    mkdir -p ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
    let-env CARAPACE_BRIDGES = "zsh,fish,bash"
}
