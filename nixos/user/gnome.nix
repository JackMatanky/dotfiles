{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.dconf.enable = true;

  programs.dconf.profiles = {
    user.databases = [
      {
        settings = with lib.gvariant; {
          # System-Level Settings: Exclude Core GNOME Applications
          "org/gnome/system/excluded-packages" = [
            "epiphany" # Web browser
            "simple-scan" # Document scanner
            "totem" # Video player
            "yelp" # Help viewer
            "gnome-font-viewer"
            "gnome-maps"
            "gnome-music"
            "gedit" # Text editor
            "gnome-connections"
            "gnome-text-editor"
            "gnome-tour" # Tour app
          ];

          # User-Level Settings
          # Input Sources
          "org/gnome/desktop/input-sources".sources = [
            (mkTuple ["xkb" "us"])
            (mkTuple ["xkb" "il"])
          ];

          # Enabled GNOME Extensions
          "org/gnome/shell".enabled-extensions = [
            "apps-menu@gnome-shell-extensions.gcampax.github.com"
            "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
            "native-window-placement@gnome-shell-extensions.gcampax.github.com"
            "places-status-indicator@gnome-shell-extensions.gcampax.github.com"
            "removable-drive-menu@gnome-shell-extensions.gcampax.github.com"
            "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "user-themes@gnome-shell-extensions.gcampax.github.com"
            "window-list@gnome-shell-extensions.gcampax.github.com"
            "windowManager@gnome-shell-extensions.gcampax.github.com"
          ];

          # Custom Shortcuts
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>e";
            command = "/usr/bin/env nautilus";
            name = "Home Folder";
          };

          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];

          # Power Settings
          "org/gnome/settings-daemon/plugins/power".sleep-inactive-battery-type = "suspend";
          "org/gnome/settings-daemon/plugins/power".power-button-action = "shutdown";
          "org/gnome/desktop/interface".show-battery-percentage = true;

          # Multitasking Settings
          "org/gnome.shell".enable-hot-corners = true;
          "org/gnome.mutter".dynamic-workspaces = true;
          "org/gnome.shell.overrides".workspaces-only-on-primary = false;
          "org/gnome.shell.app-switcher".current-workspace-only = false;
        };
      }
    ];
  };
}
