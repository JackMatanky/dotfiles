{
  config,
  pkgs,
  lib,
  ...
}: let
  myAliases = import ./aliases.nix;
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;

    initExtra = ''
      eval "$(starship init bash)"
    '';
  };
}
