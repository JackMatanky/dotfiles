# GSConnect - NixOS Wiki: https://wiki.nixos.org/wiki/KDE_Connect
{
  config,
  pkgs,
  lib,
  ...
}: let
  gnomeShellExtensionGit = "gnome-shell-extensions.gcampax.github.com";
in {
  home.packages = [
    pkgs.plasma5Packages.kdeconnect-kde
  ];

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
        "apps-menu@${gnomeShellExtensionGit}"
        "gsconnect@andyholmes.github.io"
        "native-window-placement@${gnomeShellExtensionGit}"
        "places-menu@${gnomeShellExtensionGit}"
        "drive-menu@${gnomeShellExtensionGit}"
        "screenshot-window-sizer@${gnomeShellExtensionGit}"
        "status-icons@${gnomeShellExtensionGit}"
        "system-monitor@${gnomeShellExtensionGit}"
        "window-list@${gnomeShellExtensionGit}"
        "windowsNavigator@${gnomeShellExtensionGit}"
      ];
    };

    # Interface
    "org/gnome/desktop/interface" = {
      clock-show-weekday = false;
      clock-show-seconds = false;
      show-battery-percentage = true;
      enable-hot-corners = true;
    };

    # Power Settings
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-type = "suspend";
      power-button-action = "shutdown";
    };

    # Workspace Settings
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };

    # # Multitasking Settings
    # "org/gnome.shell" = {
    #   overrides.workspaces-only-on-primary = false;
    #   app-switcher.current-workspace-only = false;
    # };

    # Custom Shortcuts
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Home Folder";
      command = "/usr/bin/env nautilus";
      binding = "<Super>e";
    };

    # Extexsions
    # Window List
    "org/gnome/shell/extensions/window-list" = {
      grouping-mode = "auto";
      display-all-workspaces = true;
      show-on-all-monitors = true;
      embed-previews = true;
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

  #           "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
  #             "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #           ];

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
