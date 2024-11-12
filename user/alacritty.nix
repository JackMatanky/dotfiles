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
      font = {
        size = 12;
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
        cursor = {
          text = "0x282a36";
          cursor = "0xf8f8f2";
        };
        selection = {
          text = "CellForeground";
          background = "#44475a";
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
      };
    };
  };
}
