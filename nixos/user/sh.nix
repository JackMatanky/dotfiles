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
    flake_update = "nix flake update";
    hm_switch = "home-manager switch --flake .";
    gc_empty = "sudo nix-garbage-collect -d";

    # Git
    gc = "git commit -m";
    gca = "git commit -a -m";
    # gp = "git push origin HEAD";
    # gpu = "git pull origin";
    # gst = "git status";
    # glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
    # gdiff = "git diff";
    # gco = "git checkout";
    # gb = "git branch";
    # gba = "git branch -a";
    # gadd = "git add";
    # ga = "git add -p";
    # gcoall = "git checkout -- .";
    # gr = "git remote";
    # gre = "git reset";

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
  };
}
