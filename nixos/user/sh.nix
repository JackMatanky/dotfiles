{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: let
  myAliases = {
    dot = "cd .dotfiles";
    dot_nix = "cd ~/.dotfiles/nixos";
    obsidian = "cd /run/media/jack/sdxc_512/obsidian_vault";

    # Nix
    flake_rebuild = "sudo nixos-rebuild switch --flake .";
    flake_up = "sudo nix flake update";
    hm_switch = "home-manager switch --flake .";
    gc_empty = "sudo nix-garbage-collect -d";

    # Git
    gad = "git add";
    gad_p = "git add -p";
    gc = "git commit -m";
    gca = "git commit -a -m";
    gps = "git push";
    gps_o = "git push origin";
    # gps_oh = "git push origin HEAD";
    gpl = "git pull";
    gpl_o = "git pull origin";
    gst = "git status";
    # glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
    # gdiff = "git diff";
    gbr = "git branch";
    gbra = "git branch -a";
    # gco = "git checkout";
    # gcoall = "git checkout -- .";
    # grm = "git remote";
    # grs = "git reset";

    # Dirs
    # .. = "cd ..";
    # ... = "cd ../..";
    # .... = "cd ../../..";
    # ..... = "cd ../../../..";
    # ...... = "cd ../../../../..";
  };
in {
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

    nushell = {
      enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
