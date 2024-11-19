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
      # Personal Knowledge Management
      anki-bin # Flashcard program
      ffmpeg # Video/audio processing (dependency for Anki)
      noto-fonts # Fonts for multilingual support
      obsidian # Markdown-based knowledge management
      zotero # Reference manager
      xournalpp # Handwriting annotation software

      # Office and Dictionaries
      libreoffice # Office suite
      hunspell # Spell checker
      hunspellDicts.en-us # English spell-check dictionary
      hunspellDicts.he-il # Hebrew spell-check dictionary

      # Media Tools
      vlc # Media player

      # Development Tools
      nixd # Nix language server (LSP)
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
    file = {
      # Shell Configuration
      ".config/aliases.sh".source = ./dotfiles/aliases.sh;
      ".bashrc".source = ./dotfiles/bashrc;
      ".zshrc".source = ./dotfiles/zshrc;
      ".config/starship/".source = ./dotfiles/starship;
      ".config/alacritty/".source = ./dotfiles/alacritty;
    };

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

    # Shell and Terminals
    # Bash Configuration
    bash = {
      enable = true; # Enable Bash as a managed program
      enableCompletion = true; # Enable command-line completion
      shellAliases = {}; # Do not set aliases in Home Manager
      # Set the custom .bashrc file location
      shellInit = ''
        if [ -f ~/.bashrc ]; then
          source ~/.bashrc
        fi
      '';
    };

    # Zsh Configuration
    zsh = {
      enable = true; # Enable Zsh as a managed program
      enableCompletion = true; # Enable command-line completion
      autosuggestion.enable = true; # Enable autosuggestions
      syntaxHighlighting.enable = true; # Enable syntax highlighting
      historySubstringSearch.enable = true; # Enable substring history search
      # Use the existing .zshrc file
      shellInit = ''
        if [ -f ~/.zshrc ]; then
          source ~/.zshrc
        fi
      '';
      # Set additional session variables
      sessionVariables = {
        TERMINAL = "${pkgs.alacritty}/bin/alacritty";
      };
    };

    # Nushell: Modern shell
    nushell = {
      enable = true; # Enable Nushell as a managed program
      configFile.source = ../nushell/config.nu;
      envFile.source = ../nushell/env.nu; # Link to the Nushell environment configuration
    };

    # Alacritty: Terminal emulator
    alacritty = {
      enable = true;
    };

    # Starship: Shell prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # Zoxide: Fast directory navigation
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # Carapace: Command-line autocompletion
    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # Git
    git = {
      enable = true;
      extraConfig = {
        include.path = "${config.home.homeDirectory}/.dotfiles/git/.gitconfig";
      };
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
