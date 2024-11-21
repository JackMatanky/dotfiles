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
    rebuild_flake = "sudo nixos-rebuild switch --flake .";
    update_flake = "nix flake update";
    switch_home = "home-manager switch --flake .";
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
