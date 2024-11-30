# Base configuration from Omer Hamerman (GitHub: omerxx)
# Source: https://github.com/omerxx/dotfiles/blob/master/nushell/config.nu

# Nushell Config File
#
# Nushell version = "0.95.0"
# This configuration has been customized for:
# - Alacritty terminal
# - Zed Editor
# - VS Code
# - Excludes vi/emacs-specific configurations

# THEMES
# Define dark and light themes for styling Nushell's appearance
let dark_theme = {
    separator: white               # Separator between elements
    header: green_bold             # Table headers
    empty: blue                    # Empty values
    bool: light_cyan               # Booleans (true/false)
    int: white                     # Integers
    string: white                  # Strings
    row_index: green_bold          # Row indexes in tables
    hints: dark_gray               # Hints for autocompletion
    search_result: {               # Search results highlighting
        bg: red
        fg: white
    }
    shape_operator: yellow         # Operators (e.g., +, -, /)
    shape_string: green            # Strings in syntax highlighting
    shape_table: blue_bold         # Table representations
    shape_variable: purple         # Variable names
}

let light_theme = {
    separator: dark_gray
    header: green_bold
    empty: blue
    bool: dark_cyan
    int: dark_gray
    string: dark_gray
    row_index: green_bold
    hints: dark_gray
    search_result: {
        fg: white
        bg: red
    }
    shape_operator: yellow
    shape_string: green
    shape_table: blue_bold
    shape_variable: purple
}

# Load the dark theme by default
$env.config = {
    color_config: $dark_theme  # Use dark_theme for styling
    use_ansi_coloring: true    # Enable ANSI colors
    use_grid_icons: true       # Show icons in grid/table views
    float_precision: 2         # Display floats with two decimal places
    show_banner: false         # Hide the Nushell banner on startup

    # FILE AND DIRECTORY SETTINGS
    ls: {
        use_ls_colors: true    # Use LS_COLORS for coloring ls output
        clickable_links: true  # Make links clickable (if supported by the terminal)
    }

    rm: {
        always_trash: true     # Move files to trash by default
    }

    # TABLE DISPLAY
    table: {
        mode: rounded          # Rounded borders for table displays
        index_mode: always     # Always show index numbers in tables
        show_empty: true       # Display "empty" placeholders
        padding: { left: 1, right: 1 }  # Add padding to columns
        trim: {
            methodology: wrapping          # Wrap text instead of truncating
            wrapping_try_keep_words: true  # Try to preserve whole words when wrapping
            truncating_suffix: "..."       # Add "..." when text is truncated
        }
    }

    # ERROR MESSAGES
    error_style: "fancy"       # Display error messages with formatting

    # HISTORY SETTINGS
    history: {
        max_size: 100_000        # Maximum history entries to store
        sync_on_enter: true      # Sync history between sessions on every command
        file_format: "plaintext" # Store history as plaintext
        isolation: false         # Share history across all sessions
    }

    # COMPLETIONS
    completions: {
        case_sensitive: false  # Completions are case-insensitive
        quick: true            # Auto-complete when only one option remains
        partial: true          # Enable partial completions
        algorithm: "prefix"    # Use prefix matching for suggestions
        external: {
            enable: true       # Include commands from PATH in completions
            max_results: 100   # Limit to 100 suggestions for better performance
        }
    }

    # FILE SIZE DISPLAY
    filesize: {
        metric: false  # Use binary units (e.g., KiB, MiB)
        format: "auto" # Automatically choose the best format
    }

    # BUFFER EDITOR
    buffer_editor: "zed"  # Use Zed Editor for editing the current line buffer

    # SHELL INTEGRATION
    shell_integration: {
        osc2: true   # Update terminal title with the current path
        osc7: true   # Communicate current directory to the terminal
        osc8: true   # Enable clickable links in terminal output
        osc133: true # Display command execution states in the terminal title
        reset_application_mode: true # Reset terminal mode for better SSH compatibility
    }

    render_right_prompt_on_last_line: false # Keep the prompt layout simple
}

# CURSOR CONFIGURATION
# Shape the cursor to appear as a beam/bar
$env.CURSOR_SHAPE = "line"   # Beam/Bar cursor
$env.CURSOR_BLINK = true     # Enable cursor blinking

# FUNCTION TO LOAD SHELL ALIASES
# Dynamically load aliases from a shell file (aliases.sh) and convert them to Nushell syntax
def load_shell_aliases [file_path] {
    # Read the content of the aliases.sh file
    let aliases = (open $file_path | lines | each { |line|
        if $line =~ /^alias / {                       # Match lines starting with `alias`
            let parts = ($line | split row "=")       # Split alias into name and command
            let alias_name = ($parts.0 | str replace "alias " "").trim()
            let alias_command = ($parts.1 | str replace "\"" "").trim()
            $"alias $alias_name = {$alias_command}"   # Format as Nushell alias
        } else {
            ""
        }
    })

    # Register each alias dynamically
    $aliases | each { |alias| if $alias != "" { eval $alias } }
}

# Example usage:
# Load aliases from the `aliases.sh` file
# Replace the path below with the actual location of your aliases.sh file
load_shell_aliases ~/.dotfiles/aliases.sh

# SOURCING ADDITIONAL CONFIGURATION
# Load external scripts and plugins
source ~/.config/nushell/env.nu
source ~/.zoxide.nu
source ~/.cache/starship/init.nu
