{
  config,
  pkgs,
  lib,
  # pkgs-unstable,
  # userSettings,
  ...
}: let
  alacrittyDir = builtins.path {
    path = ../../alacritty;
    name = "alacritty";
  };
  starshipDir = builtins.path {
    path = ../../starship;
    name = "starship";
  };

  myAliases = {
    dot = "cd ~/.dotfiles";
    dot_nix = "cd ~/.dotfiles/nixos";
    obsidian = "cd ~/obsidian_vault";
    obsidian_gpl = "cd ~/obsidian_vault; git pull";

    # Nix - Flakes
    flake_rebuild = "sudo nixos-rebuild switch --flake .";
    flake_rebuild_trace = "sudo nixos-rebuild switch --flake . --show-trace";
    flake_up = "sudo nix flake update";
    flake_up_trace = "sudo nix flake update --show-trace";

    # Nix - Home Manager
    hm_switch = "home-manager switch --flake .";
    hm_switch_trace = "home-manager switch --flake . --show-trace";

    # Nix - Garbage Collector
    cg_empty = "sudo nix-collect-garbage";
    cg_empty_all = "sudo nix-collect-garbage -d";

    # Git
    gad = "git add";
    gad_d = "git add .";
    gad_p = "git add -p";
    gc = "git commit -m";
    gca = "git commit -a -m";
    gps = "git push";
    gps_o = "git push origin";
    # gps_oh = "git push origin HEAD";
    gpl = "git pull";
    gpl_o = "git pull origin";
    gst = "git status";
    glog = "git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
    gdiff = "git diff";
    gbr = "git branch";
    gbra = "git branch -a";
    gco = "git checkout";
    gcoall = "git checkout -- .";
    grm = "git remote";
    grs = "git reset";

    # Dirs
    # .. = "cd ..";
    # ... = "cd ../..";
    # .... = "cd ../../..";
    # ..... = "cd ../../../..";
    # ...... = "cd ../../../../..";
  };
in {
  home = {
    file = {
      # ".bashrc".source = "${cliDir}/.bashrc";
      # ".zshrc".source = "${cliDir}/.zshrc";
      # ".config/nushell".source = "${cliDir}/nushell";
      ".config/alacritty/alacritty.toml".source = "${alacrittyDir}/alacritty.toml";
      ".config/starship/starship.toml".source = "${starshipDir}/starship.toml";
    };
  };
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = myAliases;

      initExtra = ''
        eval "$(starship init bash)"
      '';
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

      initExtra = ''
        eval "$(starship init zsh)"
      '';

      sessionVariables = {
        TERMINAL = "${pkgs.alacritty}/bin/alacritty";
      };
    };

    nushell = {
      enable = true;

      shellAliases = myAliases;

      # Set environment variables
      environmentVariables = {
        EDITOR = "zed"; # Set the default editor to Zed
        VISUAL = "zed";
        STARSHIP_CONFIG = "${starshipDir}/starship.toml"; # Path to the Starship configuration file
      };
    };

    alacritty = {
      enable = true;
    };

    tmux = {
      enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
    };
  };
}
