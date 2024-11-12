{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}:
# let
#   zed-fhs = pkgs.buildFHSUserEnv {
#     name = "zed";
#     targetPkgs = pkgs: with pkgs-unstable; [zed-editor];
#     runScript = "zed";
#   };
# in
{
  imports = [
    ./user
    # ./user/default.nix
    # ./user/alacritty.nix
    # ./user/git.nix
    # ./user/oh-my-posh.nix
    # ./user/ssh.nix
    # ./user/ssh.nix
  ];
  home = {
    username = userSettings.username;
    homeDirectory = "/home/${userSettings.username}";

    #SEGMENT - Environment Packages
    packages =
      (with pkgs; [
        # Personal Knowledge Management
        anki-bin
        # Anki dependencies
        ffmpeg
        noto-fonts

        obsidian
        zotero
        xournalpp

        # Office
        libreoffice
        # Dictionaries and Spellcheck
        hunspell
        hunspellDicts.en-us
        hunspellDicts.he-il

        vlc # Media Player

        # vscode # Visual Studio Code IDE.

        nixd # Nix LSP
        alejandra # Nix Formatter

        python3
        pyright # Python LSP
        python3Packages.ipykernel

        javascript-typescript-langserver
        nodejs # JavaScript runtime.

        # rclone

        # Windows apps
        # wine
        # bottles
      ])
      ++ (with pkgs-unstable; [
        zed-editor # Zed IDE
      ]);

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      x11.enable = true;
    };

    #SEGMENT - Dotfiles
    # Building this configuration will create a copy of 'dotfiles/screenrc' in the Nix store.
    # Activating the configuration will then make '~/.screenrc' a symlink to the Nix store copy.
    # file = {
    # ".screenrc".source = dotfiles/screenrc;
    # };
    #!SEGMENT

    #SEGMENT - Environment Variables
    # These will be explicitly sourced when using a shell provided by Home Manager.
    # If you don't want to manage your shell through Home Manager,
    # then you have to manually source 'hm-session-vars.sh'
    sessionVariables = {
      # Set the Qt6 platform plugin path (Anki dependency)
      QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt6.qtbase}/lib/qt6/plugins";
      EDITOR = "zed-editor";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
    };
    #!SEGMENT

    # !!! DO NOT EDIT !!!
    # Keep stateVersion as the version you originally installed.
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  # SECTION - Programs

  programs = {
    # Enable Home Manager to install and manage itself.
    home-manager = {
      enable = true;
      # useGlobalPkgs = true;
      # useUserPackages = true;
    };

    texlive = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    rtorrent = {
      enable = true;
    };

    # programs.hyprland = {
    #   enable = true;
    # };
  };
  #!SECTION

  # gtk = {
  #   enable = true;
  #   theme.name = "adw-gtk3";
  #   cursorTheme.name = "Bibata-Modern-Ice";
  #   iconTheme.name = "GruvboxPlus";
  # };

  qt = {
    enable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
