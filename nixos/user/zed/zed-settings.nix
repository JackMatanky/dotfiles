{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  inputs,
  ...
}: {
  programs.zed-editor.userSettings = {
    # Zed settings
    # https:#zed.dev/docs/configuring-zed
    "theme" = {
      "mode" = "system";
      "light" = "One Light";
      "dark" = "Base16 Dracula"; # "Gruvbox Dark";
    };
    # UI Font
    "ui_font_size" = 16;
    "ui_font_weight" = 400;
    "ui_font_family" = "Ubuntu"; #"Zed Plex Sans";
    "ui_font_fallbacks" = ["Source Code Pro"];
    "ui_font_features" = {
      # Disable ligatures:
      "calt" = false;
    };
    "base_keymap" = "VSCode";
    "features" = {
      "inline_completion_provider" = "copilot";
    };
    # Text Editor
    "buffer_font_size" = 15;
    "buffer_font_weight" = 400;
    "buffer_font_family" = "FiraCode Nerd Font";
    "buffer_font_fallbacks" = [];
    "buffer_font_features" = {
      # Disable ligatures:
      # "calt" = false
    };
    # Line height = "comfortable", "standard", {"custom" = #}
    "buffer_line_height" = "comfortable";

    "drop_target_size" = 0.2;

    "unnecessary_code_fade" = 0.3;
    "active_pane_magnification" = 1.0;

    "pane_split_direction_horizontal" = "up";
    "pane_split_direction_vertical" = "left";

    # Centered layout related settings.
    "centered_layout" = {
      "left_padding" = 0.2;
      "right_padding" = 0.2;
    };

    "vim_mode" = false;

    "hover_popover_enabled" = true;
    "confirm_quit" = false;
    "restore_on_startup" = "last_session";

    # May take 3 values = "platform_default", "close_window", "keep_window_open";
    "when_closing_with_no_tabs" = "platform_default";
    # Whether to use the system provided dialogs for Open and Save As.
    # When set to false, Zed will use the built-in keyboard-first pickers.
    "use_system_path_prompts" = true;

    # Cursor
    # Key for adding multiple cursors = "alt", "cmd_or_ctrl";
    "multi_cursor_modifier" = "alt";
    "cursor_blink" = true;
    "cursor_shape" = "bar"; # "bar" (default), "block", "underline", "hollow"
    "current_line_highlight" = "gutter"; # "none", "gutter", "line", "all" (default)

    "show_completions_on_input" = true;
    "show_completion_documentation" = true;
    "completion_documentation_secondary_query_debounce" = 300;
    "show_inline_completions" = true;
    "inline_completions" = {
      # A list of globs representing files that inline completions should be disabled for.
      "disabled_globs" = [".env"];
    };

    # Show method signatures in the editor, when inside parentheses.
    "auto_signature_help" = false;
    # If `auto_signature_help` is enabled, this setting will be treated as enabled also.
    "show_signature_help_after_edits" = true;

    # Wrap guides (vertical rulers) in the editor.
    "show_wrap_guides" = true;
    "wrap_guides" = [];

    # Private Files
    # Hide the values of in variables from visual display in private files
    "redact_private_values" = false;
    # The default number of lines to expand excerpts in the multibuffer by.
    "expand_excerpt_lines" = 3;
    # Globs to match against file paths to determine if a file is private.
    "private_files" = [
      "**/.env*"
      "**/*.pem"
      "**/*.key"
      "**/*.cert"
      "**/*.crt"
      "**/secrets.yml"
    ];

    # Whether to use additional LSP queries to format (and amend) the code after
    # every "trigger" symbol input, defined by LSP server capabilities.
    "use_on_type_format" = true;

    "use_autoclose" = true;
    "use_auto_surround" = true;
    "always_treat_brackets_as_autoclosed" = false;

    # Whether to show tabs and spaces in the editor.
    # "selection" (default), "none", "all", "boundary"
    "show_whitespaces" = "selection";

    # Calls
    "calls" = {
      "mute_on_join" = false;
      "share_on_join" = false;
    };

    # Toolbar
    "toolbar" = {
      "breadcrumbs" = true;
      "quick_actions" = true;
      "selections_menu" = true;
    };

    # Scrollbar
    "scrollbar" = {
      "show" = "auto"; # "auto" (default), "system", "always", "never"
      "cursors" = true; # Show cursor positions.
      "git_diff" = true; # Show git diff indicators.
      "search_results" = true; # Show buffer search results.
      "selected_symbol" = true; # Show selected symbol occurrences.
      "diagnostics" = true; # Show diagnostic indicators.
    };

    # Enable middle-click paste on Linux.
    "middle_click_paste" = true;

    "double_click_in_multibuffer" = "select";

    # Gutter
    "gutter" = {
      "line_numbers" = true; # Show line numbers.
      "code_actions" = true; # Show code action buttons.
      "runnables" = true; # Show runnables buttons.
      "folds" = true; # Show fold buttons.
    };
    "relative_line_numbers" = true;

    # Indent Guides
    "indent_guides" = {
      "enabled" = true;
      "line_width" = 2; # Pixels, between 1 and 10.
      "active_line_width" = 3; # Pixels, between 1 and 10.
      "coloring" = "indent_aware"; # "disabled", "fixed", "indent_aware"
      "background_coloring" = "disabled"; # "disabled", "indent_aware"
    };

    # Whether the editor will scroll beyond the last line.
    "scroll_beyond_last_line" = "one_page";
    # The number of lines to keep above/below the cursor when scrolling.
    "vertical_scroll_margin" = 3;
    # Scroll sensitivity multiplier. This multiplier is applied
    # to both the horizontal and vertical delta values while scrolling.
    "scroll_sensitivity" = 1.0;

    # Search
    "search" = {
      "whole_word" = false;
      "case_sensitive" = false;
      "include_ignored" = false;
      "regex" = false;
    };
    # If 'search_wrap' is disabled, search result do not wrap around the end of the file.
    "search_wrap" = true;
    # When to populate a new search's query based on the text under the cursor.
    # This setting can take the following three values:
    #
    # 1. Always populate the search query with the word under the cursor (default).
    #    "always"
    # 2. Only populate the search query when there is text selected
    #    "selection"
    # 3. Never populate the search query
    #    "never"
    "seed_search_query_from_cursor" = "always";
    "use_smartcase_search" = false;

    # Inlay Hints
    "inlay_hints" = {
      "enabled" = true;
      "show_type_hints" = true;
      "show_parameter_hints" = true;
      # Corresponds to null/None LSP hint type value.
      "show_other_hints" = true;
      # If `true`, the current theme's `hint.background` color is applied.
      "show_background" = false;
      # Time to wait before requesting the hints. 0 disables debouncing.
      "edit_debounce_ms" = 700; # After editing the buffer.
      "scroll_debounce_ms" = 50; # After scrolling the buffer.
    };

    # Project Panel
    "project_panel" = {
      "button" = true;
      "default_width" = 240;
      "dock" = "left";
      "auto_fold_dirs" = false;
      "folder_icons" = true;
      "file_icons" = true;
      "git_status" = true;
      "auto_reveal_entries" = true;
      "scrollbar" = {
        "show" = "auto"; # "auto", "system", "always", "never"
      };
      "indent_size" = 20;
      "indent_guides" = {
        "show" = "always";
      };
    };

    # Outline Panel
    "outline_panel" = {
      "button" = true;
      "default_width" = 300;
      "dock" = "left";
      "auto_fold_dirs" = true;
      "folder_icons" = true;
      "file_icons" = true;
      "git_status" = true;
      "auto_reveal_entries" = true;
      "indent_size" = 20;
      "indent_guides" = {
        "show" = "always";
      };
    };

    # Collaboration Panel
    "collaboration_panel" = {
      "button" = true;
      "dock" = "left";
      "default_width" = 240;
    };

    # Chat Panel
    "chat_panel" = {
      "button" = true;
      "dock" = "right";
      "default_width" = 240;
    };

    # Message Editor
    "message_editor" = {
      "auto_replace_emoji_shortcode" = true;
    };

    # Notification Panel
    "notification_panel" = {
      "button" = true;
      "dock" = "right";
      "default_width" = 380;
    };

    "assistant" = {
      "version" = "2";
      "enabled" = true;
      "button" = true;
      "dock" = "right";
      "default_width" = 640;
      "default_height" = 320;
      "default_model" = {
        "provider" = "zed.dev";
        "model" = "claude-3-5-sonnet-latest";
      };
    };
    # Slash Commands
    "slash_commands" = {
      "docs" = {
        "enabled" = true;
      };
      "project" = {
        "enabled" = true;
      };
    };
    # Whether the screen sharing icon is shown in the os status bar.
    "show_call_status_icon" = true;

    "enable_language_server" = true;
    # The list of language servers to use (or disable) for all languages.
    # This is typically customized on a per-language basis.
    "language_servers" = ["..."];

    # Whether to perform linked edits of associated ranges, if the language server supports it.
    # For example, when editing opening <html> tag, the contents of the closing </html> tag will be edited as well.
    "linked_edits" = true;

    # When to automatically save edited buffers.
    # "off", "on_window_change", "on_focus_change", { "after_delay" = {"milliseconds" = 500} };
    "autosave" = "off";

    # Editor's Tab Bar
    "tab_bar" = {
      "show" = true;
      "show_nav_history_buttons" = true;
    };

    # Editor's Tabs
    "tabs" = {
      "git_status" = true;
      "close_position" = "right"; # Button Position
      "file_icons" = true;
      # Tab to activate after closing the current tab.
      # 1. The previously tab (default) = "History"
      # 2. The neighbour tab = "Neighbour"
      "activate_on_close" = "history";
    };

    # Preview Tabs.
    "preview_tabs" = {
      "enabled" = true;
      "enable_preview_from_file_finder" = false;
      "enable_preview_from_code_navigation" = false;
    };

    # File Finder.
    "file_finder" = {
      "file_icons" = true;
    };

    "remove_trailing_whitespace_on_save" = true;
    "extend_comment_on_newline" = true;
    "ensure_final_newline_on_save" = true;

    # Control what info is collected by Zed.
    "telemetry" = {
      "diagnostics" = true;
      "metrics" = true;
    };

    # Automatically update Zed. This setting may be ignored on Linux if
    # installed through a package manager.
    "auto_update" = true;
    # Diagnostics configuration.
    "diagnostics" = {
      "include_warnings" = true;
    };
    # Add files or globs of files that will be excluded by Zed entirely:
    # they will be skipped during FS scan(s), file tree and file search
    # will lack the corresponding file entries.
    "file_scan_exclusions" = [
      "**/.git"
      "**/.svn"
      "**/.hg"
      "**/CVS"
      "**/.DS_Store"
      "**/Thumbs.db"
      "**/.classpath"
      "**/.settings"
    ];

    # Git Gutter
    "git" = {
      "git_gutter" = "tracked_files";
      "inline_blame" = {
        "enabled" = true;
        # Sets a delay after which the inline blame information is shown.
        # Delay is restarted with every cursor movement.
        # "delay_ms" = 600
      };
    };

    # Configuration for how direnv configuration should be loaded. May take 2 values:
    # 1. Load direnv configuration using `direnv export json` directly.
    #      "load_direnv" = "direct"
    # 2. Load direnv configuration through the shell hook, works for POSIX shells and fish.
    #      "load_direnv" = "shell_hook"
    "load_direnv" = "direct";

    # Settings specific to journaling
    "journal" = {
      # The directory path for storing journal entries
      "path" = "~";
      "hour_format" = "hour24";
    };

    # Terminal
    "terminal" = {
      # What shell to use when opening a terminal. May take 3 values:
      # 1. Use the system's default terminal configuration in /etc/passwd
      #      "shell" = "system"
      # 2. A program:
      #      "shell" = {
      #        "program" = "sh"
      #      }
      # 3. A program with arguments:
      #     "shell" = {
      #         "with_arguments" = {
      #           "program" = "/bin/bash";
      #           "args" = ["--login"]
      #         }
      #     }
      "shell" = "system";
      "dock" = "bottom"; # `left`, `right`, `bottom`.
      "default_width" = 640; # For side docking
      "default_height" = 320; # For bottom docking
      # What working directory to use when launching the terminal.
      # May take 4 values:
      # 1. Use the current file's project directory.  Will Fallback to the
      #    first project directory strategy if unsuccessful
      #      "working_directory" = "current_project_directory"
      # 2. Use the first project in this workspace's directory
      #      "working_directory" = "first_project_directory"
      # 3. Always use this platform's home directory (if we can find it)
      #     "working_directory" = "always_home"
      # 4. Always use a specific directory. This value will be shell expanded.
      #    If this path is not a valid directory the terminal will default to
      #    this platform's home directory  (if we can find it)
      #      "working_directory" = {
      #        "always" = {
      #          "directory" = "~/zed/projects/"
      #        }
      #      }
      "working_directory" = "current_project_directory";
      # Any key-value pairs added to this list will be added to the terminal's
      # environment. Use `:` to separate multiple values.
      env = {
        TERM = "alacritty";
      };
      # Activate the python virtual environment, if one is found, in the
      # terminal's working directory (as resolved by the working_directory
      # setting). Set this to "off" to disable this behavior.
      "detect_venv" = {
        "on" = {
          # Default directories to search for virtual environments, relative
          # to the current working directory. We recommend overriding this
          # in your project's settings, rather than globally.
          "directories" = [".env" "env" ".venv" "venv"];
          # Can also be `csh`, `fish`, `nushell` and `power_shell`
          "activate_script" = "default";
        };
      };
      "button" = true;
      "toolbar" = {
        "title" = true;
      };
      "alternate_scroll" = "off";
      "option_as_meta" = false;
      "copy_on_select" = false;
      "line_height" = "comfortable";
      "cursor_shape" = "bar";
      "blinking" = "terminal_controlled"; # "on" to always blink the cursor
      # Set the terminal's font size. If this option is not included;
      # the terminal will default to matching the buffer's font size.
      # "font_size" = 15;
      # Set the terminal's font family. If this option is not included;
      # the terminal will default to matching the buffer's font family.
      "font_family" = "FiraCode Nerd Font"; #"Source Code Pro";
      # Set the terminal's font fallbacks. If this option is not included;
      # the terminal will default to matching the buffer's font fallbacks.
      # This will be merged with the platform's default font fallbacks
      "font_fallbacks" = ["Source Code Pro"];
      # Sets the maximum number of lines in the terminal's scrollback buffer.
      # Default = 10_000, maximum = 100_000 (all bigger values set will be treated as 100_000), 0 disables the scrolling.
      # Existing terminals will not pick up this change until they are recreated.
      # "max_scroll_history_lines" = 10000;
    };
    "code_actions_on_format" = {};

    # Tasks.
    "tasks" = {
      "variables" = {};
    };
    "toolchain" = {
      "name" = "default";
      "path" = "default";
    };

    # File Types
    "file_types" = {
      "Plain Text" = ["txt"];
      "JSON" = ["flake.lock"];
      "JSONC" = [
        "**/.zed/**/*.json"
        "**/zed/**/*.json"
        "**/Zed/**/*.json"
        "tsconfig.json"
        "pyrightconfig.json"
      ];
      "TOML" = ["uv.lock"];
    };

    # By default use a recent system version of node, or install our own.
    # You can override this to use a version of node that is not in $PATH with:
    # {
    #   "node" = {
    #     "path" = "/path/to/node"
    #     "npm_path" = "/path/to/npm" (defaults to node_path/../npm)
    #   }
    # }
    # or to ensure Zed always downloads and installs an isolated version of node:
    # {
    #   "node" = {
    #     "ignore_system_version" = true;
    #   }
    # NOTE = changing this setting currently requires restarting Zed.
    node = {
      path = lib.getExe pkgs.nodejs;
      npm_path = lib.getExe' pkgs.nodejs "npm";
    };

    # Automatically Installed Extensions
    "auto_install_extensions" = {
      "base16" = true;
      "basher" = false;
      "csv" = true;
      "dbml" = false;
      "git-firefly" = true;
      "html" = true;
      "just" = false;
      "latex" = true;
      "markdown-oxide" = false;
      "mermaid" = false;
      "nix" = true;
      "pylsp" = true;
      "python-refactoring" = true;
      "rainbow-csv" = true;
      "ruff" = true;
      "sagemath" = false;
      # "snippets" = true;
      "sql" = true;
      "toml" = false;
      "typst" = true;
    };

    # Formatter
    "format_on_save" = "on";
    # How to perform a buffer format. This setting can take 4 values:
    #
    # 1. Format code using the current language server:
    #     "formatter" = "language_server"
    # 2. Format code using an external command:
    #     "formatter" = {
    #       "external" = {
    #         "command" = "prettier";
    #         "arguments" = ["--stdin-filepath", "{buffer_path}"]
    #       }
    #     }
    # 3. Format code using Zed's Prettier integration:
    #     "formatter" = "prettier"
    # 4. Default. Format files using Zed's Prettier integration (if applicable);
    #    or falling back to formatting via language server:
    #     "formatter" = "auto"
    "formatter" = "auto";
    # Zed's Prettier integration settings.
    "prettier" = {
      # # Whether to consider prettier formatter or not when attempting to format a file.
      # "allowed" = false;
      #
      # # Use regular Prettier json configuration.
      # # If Prettier is allowed, Zed will use this for its Prettier instance for any applicable file, if
      # # the project has no other Prettier installed.
      # "plugins" = [];
      #
      # # Use regular Prettier json configuration.
      # # If Prettier is allowed, Zed will use this for its Prettier instance for any applicable file, if
      # # the project has no other Prettier installed.
      # "trailingComma" = "es5";
      # "tabWidth" = 4;
      # "semi" = false;
      # "singleQuote" = true
    };

    # How to soft-wrap long lines of text.
    # Possible values:
    #
    # 1. Prefer a single line generally, unless an overly long line is encountered.
    #      "soft_wrap" = "none";
    #      "soft_wrap" = "prefer_line"; # (deprecated, same as "none")
    # 2. Soft wrap lines that overflow the editor.
    #      "soft_wrap" = "editor_width";
    # 3. Soft wrap lines at the preferred line length.
    #      "soft_wrap" = "preferred_line_length";
    # 4. Soft wrap lines at the preferred line length or the editor width (whichever is smaller).
    #      "soft_wrap" = "bounded";
    "soft_wrap" = "editor_width";
    "preferred_line_length" = 80;
    "hard_tabs" = false;
    "tab_size" = 4;

    # Language Settings
    "languages" = {
      "Astro" = {
        "language_servers" = ["astro-language-server" "..."];
        "prettier" = {
          "allowed" = true;
          "plugins" = ["prettier-plugin-astro"];
        };
      };
      "Blade" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "C" = {
        "format_on_save" = "off";
        "use_on_type_format" = false;
      };
      "C++" = {
        "format_on_save" = "off";
        "use_on_type_format" = false;
      };
      "CSS" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "Dart" = {
        "tab_size" = 2;
      };
      "Diff" = {
        "remove_trailing_whitespace_on_save" = false;
        "ensure_final_newline_on_save" = false;
      };
      "Elixir" = {
        "language_servers" = ["elixir-ls" "!next-ls" "!lexical" "..."];
      };
      "Erlang" = {
        "language_servers" = ["erlang-ls" "!elp" "..."];
      };
      "Go" = {
        "code_actions_on_format" = {
          "source.organizeImports" = true;
        };
      };
      "GraphQL" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "HEEX" = {
        "language_servers" = ["elixir-ls" "!next-ls" "!lexical" "..."];
      };
      "HTML" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "Java" = {
        "prettier" = {
          "allowed" = true;
          "plugins" = ["prettier-plugin-java"];
        };
      };
      "JavaScript" = {
        "tab_size" = 2;
        "language_servers" = ["!typescript-language-server" "vtsls" "..."];
        "prettier" = {
          "allowed" = true;
        };
      };
      "JSON" = {
        "tab_size" = 2;
        "prettier" = {
          "allowed" = true;
        };
      };
      "JSONC" = {
        "tab_size" = 2;
        "prettier" = {
          "allowed" = true;
        };
      };
      "LaTeX" = {
        "language_servers" = ["tex"];
      };
      "Markdown" = {
        "format_on_save" = "off";
        "use_on_type_format" = false;
        "prettier" = {
          "allowed" = true;
        };
      };
      "Nix" = {
        "tab_size" = 2;
        "format_on_save" = "on";
        "formatter" = {
          "external" = {
            "command" = "alejandra";
            "arguments" = ["-"];
          };
        };
      };
      "PHP" = {
        "language_servers" = ["phpactor" "!intelephense" "..."];
        "prettier" = {
          "allowed" = true;
          "plugins" = ["@prettier/plugin-php"];
          "parser" = "php";
        };
      };
      "Python" = {
        "language_servers" = ["!pyright" "!ruff" "pylsp"];
        "tab_size" = 4;
        "format_on_save" = "on";
        "formatter" = {
          "external" = {
            "command" = "/home/jack/.nix-profile/bin/ruff";
            "arguments" = ["format" "--stdin-filename" "{buffer_path}"];
          };
        };
        # [
        #   {
        #     "code_actions" = {
        #       # Fix all auto-fixable lint violations
        #       "source.fixAll.ruff" = true;
        #       # Organize imports
        #       "source.organizeImports.ruff" = true
        #     };
        #   };
        #   {
        #     "language_server" = {
        #       "name" = "ruff"
        #     };
        #   };
        # ]
      };
      "Ruby" = {
        "language_servers" = ["solargraph" "!ruby-lsp" "!rubocop" "..."];
      };
      "SCSS" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "SQL" = {
        "tab_size" = 4;
        "prettier" = {
          "allowed" = true;
          "plugins" = ["prettier-plugin-sql"];
        };
      };
      "Starlark" = {
        "language_servers" = ["starpls" "!buck2-lsp" "..."];
      };
      "Svelte" = {
        "language_servers" = ["svelte-language-server" "..."];
        "prettier" = {
          "allowed" = true;
          "plugins" = ["prettier-plugin-svelte"];
        };
      };
      "TSX" = {
        "language_servers" = ["!typescript-language-server" "vtsls" "..."];
        "prettier" = {
          "allowed" = true;
        };
      };
      "Twig" = {
        "prettier" = {
          "allowed" = true;
        };
      };
      "TypeScript" = {
        "language_servers" = ["!typescript-language-server" "vtsls" "..."];
        "prettier" = {
          "allowed" = true;
        };
      };
      "Vue.js" = {
        "language_servers" = ["vue-language-server" "..."];
        "prettier" = {
          "allowed" = true;
        };
      };
      "XML" = {
        "prettier" = {
          "allowed" = true;
          "plugins" = ["@prettier/plugin-xml"];
        };
      };
      "YAML" = {
        "prettier" = {
          "allowed" = true;
        };
      };
    };

    # Language Server Protocol (LSP)
    "lsp" = {
      nix = {
        binary = {
          path_lookup = true;
        };
      };
      # "snippet-completion-server" = {
      #   "binary" = {
      #     "path" = "/home/jack/.nix-profile/bin/simple-completion-language-server"
      #   };
      #   "command" = "simple-completion-language-server";
      #   "languages" = ["plaintext"]
      # };
      "pylsp" = {
        "binary" = {
          "path" = "/home/jack/.nix-profile/bin/pylsp";
        };
        "settings" = {
          "plugins" = {
            "pylsp-mypy" = {
              "enabled" = true;
            };
            "pylsp-rope" = {
              "enabled" = true;
            };
            "python-lsp-ruff" = {
              "enabled" = true;
            };
          };
        };
      };
      "pyright" = {
        "binary" = {
          "path" = "/home/jack/.nix-profile/bin/pyright";
        };
        "settings" = {
          "python.analysis" = {
            "diagnosticMode" = "workspace";
            "typeCheckingMode" = "strict";
          };
          "python" = {
            "pythonPath" = "/home/jack/.nix-profile/bin/python";
          };
        };
      };
      "ruff" = {
        "binary" = {
          "path" = "/home/jack/.nix-profile/bin/ruff";
          "arguments" = ["server" "--preview"];
        };
      };
      #   # "initialization_options" = {
      #   #   "settings" = {
      #   #     "path" = "/home/jack/.nix-profile/bin/ruff";
      #   #   };
      #   # };
      # };
      "tex" = {
        "binary" = {
          "path" = "/home/jack/.nix-profile/bin/tex";
        };
      };
    };

    # Jupyter Notebook
    "jupyter" = {
      "enabled" = true;
      # Specify the language name as the key and the kernel name as the value.
      # "kernel_selections" = {
      #    "python" = "conda-base";
      #    "typescript" = "deno";
      # };
    };

    # Vim
    "vim" = {
      "toggle_relative_line_numbers" = false;
      "use_system_clipboard" = "always";
      "use_multiline_find" = false;
      "use_smartcase_find" = false;
      "custom_digraphs" = {};
    };

    # Language Models.
    "language_models" = {
      "anthropic" = {
        "version" = "1";
        "api_url" = "https:#api.anthropic.com";
      };
      "google" = {
        "api_url" = "https:#generativelanguage.googleapis.com";
      };
      "ollama" = {
        "api_url" = "http:#localhost:11434";
        "low_speed_timeout_in_seconds" = 60;
      };
      "openai" = {
        "version" = "1";
        "api_url" = "https:#api.openai.com/v1";
        "low_speed_timeout_in_seconds" = 600;
      };
    };

    "server_url" = "https:#zed.dev";
    "preview" = {};
    "nightly" = {};
    "stable" = {};
    "dev" = {};

    # Task-related settings.
    "task" = {
      "show_status_indicator" = true;
    };

    "line_indicator_format" = "long"; # `short` = "2 s, 15 l, 32 c";

    # Set a proxy to use. The proxy protocol is specified by the URI scheme.
    #
    # Supported URI scheme = `http`, `https`, `socks4`, `socks4a`, `socks5`;
    # `socks5h`. `http` will be used when no scheme is specified.
    #
    # By default no proxy will be used, or Zed will try get proxy settings from
    # environment variables.
    #
    # Examples:
    #   - "proxy" = "socks5h:#localhost:10808";
    #   - "proxy" = "http:#127.0.0.1:10809";
    "proxy" = "";

    # Command Palette Aliases
    "command_aliases" = {};

    # SSH Connections
    # Examples:
    # [
    #   {
    #     "host" = "example-box";
    #     # "port" = 22, "username" = "test", "args" = ["-i", "/home/user/.ssh/id_rsa"]
    #     "projects" = [
    #       {
    #         "paths" = ["/home/user/code/zed"]
    #       };
    #     ]
    #   };
    # ]
    "ssh_connections" = [];

    # Configures the Context Server Protocol binaries
    #
    # Examples:
    # {
    #   "id" = "server-1";
    #   "executable" = "/path";
    #   "args" = ['arg1", "args2"]
    # };
    "experimental.context_servers" = {
      "servers" = [];
    };
  };
}