{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: let
  myAliases = {
    dot = "cd .dotfiles";
    obsidian = "cd /run/media/jack/sdxc_512/obsidian_vault";
    flake_rebuild = "sudo nixos-rebuild switch --flake .";
    flake_up = "sudo nix flake update";
    hm_switch = "home-manager switch --flake .";

    # Shell Commands
    l = "ls --all";                     # List all files
    ll = "ls -l";                       # List files in long format
    clear = "clearscreen";              # Clear the screen
    code = "code .";                    # Open VS Code in the current directory
    z = "zed";                          # Open Zed Editor

    # GIT SHORTCUTS
    gcm = "git commit -m";              # Commit with a message
    gcam = "git commit -a -m";          # Add and commit with a message
    gps = "git push";                   # Push current branch
    gpso = "git push origin HEAD";      # Push current branch
    gpl = "git pull";                   # Pull updates from the remote
    gplo = "git pull origin";           # Pull updates from the remote
    gst = "git status";                 # Show Git status
    gdiff = "git diff";                 # Show Git differences
    gco = "git checkout";               # Switch branches
    gb = "git branch";                  # List branches
  };
in {
  home.file = {
      ".config/starship/starship.toml".source = ../.starship/starship.toml;
      ".config/alacritty/alacritty.toml".source = ../.alacritty/alacritty.toml;
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.searchUpKey = ["^[[A"];
      shellAliases = myAliases;

      # history = {
      # size = 10000;
      # };
      sessionVariables = {
        TERMINAL = "${pkgs.alacritty}/bin/alacritty";
      };
    };

    # Nushell: Modern shell
    nushell = {
      enable = true; # Enable Nushell as a managed program
      configFile.source = ../.nushell/config.nu;
      envFile.source = ../.nushell/env.nu; # Link to the Nushell environment configuration
      };
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
  };
}
