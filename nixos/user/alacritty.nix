{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      terminal.shell = {
        program = "/home/jack/.nix-profile/bin/nu";
        args = ["--login"];
      };
      font = {
        size = 12;
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code";
          style = "Bold Italic";
        };
        # draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      # Set cursor to a bar style
      cursor.style = "Beam";
      # Define a theme (example: dark theme)
      colors = {
        primary = {
          # background = "0x282936"; # Dark background
          # foreground = "0xf8f8f2"; # Light text color
          background = "0x282a36";
          foreground = "0xf8f8f2";
          bright_foreground = "0xffffff";
        };
        normal = {
          black = "0x21222C";
          red = "0xFF5555"; # Red for errors
          green = "0x50FA7B"; # Green for success
          yellow = "0xF1FA8C"; # Yellow for warnings
          blue = "0xBD93F9"; # Blue for info
          magenta = "0xFF79C6"; # Magenta for special
          cyan = "0x8BE9FD"; # Cyan for variables, etc.
          white = "0xBFBFBF"; # Light gray text
        };
        bright = {
          black = "0x6272A4"; # Brightened black
          red = "0xFF6E6E"; # Bright red
          green = "0x69FF94"; # Bright green
          yellow = "0xFFFFA5"; # Bright yellow
          blue = "0xD6ACFF"; # Bright blue
          magenta = "0xFF92DF"; # Bright magenta
          cyan = "0xA4FFFF"; # Bright cyan
          white = "0xFFFFFF"; # Pure white for bright text
        };
        cursor = {
          text = "0x282a36";
          cursor = "0xf8f8f2";
        };
        selection = {
          text = "CellForeground";
          background = "#44475a";
        };
        search = {
          matches = {
            foreground = "0x44475a";
            background = "0x50fa7b";
          };
          focused_match = {
            foreground = "0x44475a";
            background = "0xffb86c";
          };
        };
        footer_bar = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        hints = {
          start = {
            foreground = "0x282a36";
            background = "0xf1fa8c";
          };
          end = {
            foreground = "0xf1fa8c";
            background = "0x282a36";
          };
        };
        # keyboard = {
        bindings = [
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
          {
            key = "Paste";
            action = "Paste";
          }
          {
            key = "Copy";
            action = "Copy";
          }
          {
            key = "Insert";
            mods = "Shift";
            action = "PasteSelection";
          }
          {
            key = "F";
            mods = "Control|Shift";
            action = "SearchForward";
            mode = "~Search";
          }
          {
            key = "B";
            mods = "Control|Shift";
            action = "SearchBackward";
            mode = "~Search";
          }
          {
            key = "Key0";
            mods = "Control";
            action = "ResetFontSize";
          }
          {
            key = "Equals";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "L";
            mods = "Control";
            action = "ClearLogNotice";
          }
          {
            key = "L";
            mods = "Control";
            chars = "\f";
          }
          {
            key = "PageUp";
            mods = "Shift";
            action = "ScrollPageUp";
            mode = "~Alt";
          }
          {
            key = "PageDown";
            mods = "Shift";
            action = "ScrollPageDown";
            mode = "~Alt";
          }
          {
            key = "Up";
            mods = "Shift";
            action = "ScrollLineUp";
            mode = "~Alt";
          }
          {
            key = "Down";
            mods = "Shift";
            action = "ScrollLineDown";
            mode = "~Alt";
          }
          {
            key = "Home";
            mods = "Shift";
            action = "ScrollToTop";
            mode = "~Alt";
          }
          {
            key = "End";
            mods = "Shift";
            action = "ScrollToBottom";
            mode = "~Alt";
          }
        ];
        # };
      };
    };
  };
}
