{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  # Import additional configurations if needed
  imports = [
    ./user
  ];

  # Home Manager Configuration
  home = {
    username = userSettings.username;
    homeDirectory = "/home/${userSettings.username}";

    # Environment Packages
    # Packages installed in the user's environment
    packages = with pkgs; [
      # Office and Dictionaries
      libreoffice # Office suite
      hunspell # Spell checker
      hunspellDicts.en-us # English spell-check dictionary
      hunspellDicts.he-il # Hebrew spell-check dictionary

      # Media Tools
      vlc # Media player

      # Development Tools
      nixd # Nix language server (LSP)
      nil
      alejandra # Nix code formatter
      javascript-typescript-langserver # JS/TS LSP
      nodejs # JavaScript runtime
    ];

    # Pointer Cursor Configuration
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      x11.enable = true;
    };

    # Dotfiles
    # Symlink configuration files to the user's home directory
    # file = {
    # };

    # Environment Variables
    # Define global variables for the user environment
    sessionVariables = {
      QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt6.qtbase}/lib/qt6/plugins"; # Required for Anki
      EDITOR = "zed-editor";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/starship/starship.toml"; # Starship configuration file
    };

    # !!! DO NOT EDIT !!!
    # Keep stateVersion as the version you originally installed.
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  # User Programs
  programs = {
    # Home Manager
    home-manager = {
      enable = true; # Manage user configuration with Home Manager
      # useGlobalPkgs = true;
      # useUserPackages = true;
    };

    # TeX Live
    texlive = {
      enable = true; # Enable LaTeX support
    };

    # Firefox
    firefox = {
      enable = true; # Install Firefox browser
    };

    # rTorrent
    rtorrent = {
      enable = true; # Enable rTorrent for downloading torrents
    };
  };

  # QT Settings
  qt = {
    enable = true;
  };

  # Nixpkgs Settings
  nixpkgs = {
    config = {
      allowUnfree = true; # Allow installation of unfree packages
      allowUnfreePredicate = _: true; # Enable unfree packages globally
    };
  };
}
