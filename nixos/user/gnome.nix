# GSConnect - NixOS Wiki: https://wiki.nixos.org/wiki/KDE_Connect
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.kdeconnect
  ];
  services = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  dconf.settings = {
    # Enabled GNOME Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "window-navigator@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    # Interface
    "org/gnome/desktop/interface" = {
      clock-show-weekday = false;
      clock-show-seconds = false;
      show-battery-percentage = true;
      enable-hot-corners = true;
    };

    # Custom Shortcuts
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Home Folder";
      command = "/usr/bin/env nautilus";
      binding = "<Super>e";
    };
  };
  # dconf.settings = {
  #         # settings = with lib.gvariant; {
  #         #   # System-Level Settings: Exclude Core GNOME Applications
  #         #   "org/gnome/system/excluded-packages" = [
  #         #     "epiphany" # Web browser
  #         #     "simple-scan" # Document scanner
  #         #     "totem" # Video player
  #         #     "yelp" # Help viewer
  #         #     "gnome-font-viewer"
  #         #     "gnome-maps"
  #         #     "gnome-music"
  #         #     "gedit" # Text editor
  #         #     "gnome-connections"
  #         #     "gnome-text-editor"
  #         #     "gnome-tour" # Tour app
  #         #   ];

  #           # User-Level Settings
  #           # Input Sources
  #           "org/gnome/desktop/input-sources".sources = [
  #             (mkTuple ["xkb" "us"])
  #             (mkTuple ["xkb" "il"])
  #           ];

  #           # Enabled GNOME Extensions
  #           "org/gnome/shell" = {
  #             disable-user-extensions = false;
  #             enabled-extensions = [
  #               "apps-menu@gnome-shell-extensions.gcampax.github.com"
  #               "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
  #               "native-window-placement@gnome-shell-extensions.gcampax.github.com"
  #               "places-status-indicator@gnome-shell-extensions.gcampax.github.com"
  #               "removable-drive-menu@gnome-shell-extensions.gcampax.github.com"
  #               "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
  #               "system-monitor@gnome-shell-extensions.gcampax.github.com"
  #               "user-themes@gnome-shell-extensions.gcampax.github.com"
  #               "window-list@gnome-shell-extensions.gcampax.github.com"
  #               "windowManager@gnome-shell-extensions.gcampax.github.com"
  #             ];
  #           };

  #           # Custom Shortcuts
  #           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #             name = "Home Folder";
  #             command = "/usr/bin/env nautilus";
  #             binding = "<Super>e";
  #           };

  #           "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
  #             "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #           ];

  #           # Power Settings
  #           "org/gnome/settings-daemon/plugins/power" = {
  #             sleep-inactive-battery-type = "suspend";
  #             power-button-action = "shutdown";
  #           };

  #           # Interface Settings
  #           "org/gnome/desktop/interface" = {
  #             clock-show-weekday = false;
  #             clock-show-seconds = false;
  #             show-battery-percentage = true;
  #             gtk-theme = "Adwaita-dark";
  #             enable-hot-corners = true;
  #           };

  #           # Workspace Settings
  #           "org/gnome/mutter" = {
  #             dynamic-workspaces = true;
  #           };

  #           # Multitasking Settings
  #           "org/gnome.shell" = {
  #             enable-hot-corners = true;
  #             overrides.workspaces-only-on-primary = false;
  #             app-switcher.current-workspace-only = false;
  #           };
  #         };
  #       }
  #     ];
  #   };
  # };
}
