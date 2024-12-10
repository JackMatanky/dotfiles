{
  config,
  pkgs,
  lib,
  ...
}: let
  myAliases = import ./aliases.nix;
in {
  programs.zsh = {
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
}
