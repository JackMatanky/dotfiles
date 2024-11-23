# Nushell Config File
#
# version = "0.95.0"

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

let light_theme = {
    # color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    bool: dark_cyan
    int: dark_gray
    filesize: cyan_bold
    duration: dark_gray
    date: purple
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cell-path: dark_gray
    row_index: green_bold
    record: dark_gray
    list: dark_gray
    block: dark_gray
    hints: dark_gray
    search_result: { fg: white bg: red }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_purple_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

# Environment configuration
# These settings control the shell's behavior, such as table formatting and error messages
let-env config = {
    use_ls_colors: true  # Use `LS_COLORS` for coloring `ls` output
    table_mode: rounded  # Use rounded borders for tables
    error_style: "fancy"  # Display detailed error messages
    edit_mode: vi  # Use vi-style navigation in the command line
    color_config: $dark_theme  # Apply the dark theme
    shell_integration: {
        osc2: true  # Update terminal tab titles with the current directory
        osc7: true  # Pass the current directory to the terminal
        osc8: true  # Enable clickable links in ls output
        osc133: true  # Mark prompt boundaries for better terminal integration
    }
}

# Source external aliases from a shell script
# This script should contain alias definitions compatible with Nushell
def source_aliases [] {
    if (not (path exists ~/.config/nushell/aliases.sh)) {
        echo "aliases.sh not found, skipping alias import"
        return
    }

    let lines = (open ~/.config/nushell/aliases.sh | lines)
    for line in $lines {
        if ($line | str starts-with '#') or ($line | str trim == '') {
            continue  # Skip comments and empty lines
        }
        let parts = ($line | str split '=' | str trim)
        if ($parts | length) != 2 {
            continue  # Skip lines that don't match the alias format
        }
        let alias_name = ($parts | first)
        let alias_command = ($parts | last | str replace '"' '' | str replace "'" '')
        alias $alias_name = $alias_command
    }
}

# Call the function to source aliases
source_aliases

# Example custom function
# Replace or expand this with your own commands
def ff [] {
    echo "Custom function example"
}

# Plugins and integrations
# These integrations are optional and will only be sourced if their files exist
if (path exists ~/.cache/carapace/init.nu) {
    source ~/.cache/carapace/init.nu  # Source Carapace integration for command completion
} else {
    echo "Carapace integration not found, skipping"
}

if (path exists ~/.cache/starship/init.nu) {
    use ~/.cache/starship/init.nu  # Use Starship for prompt customization
} else {
    echo "Starship integration not found, skipping"
}
