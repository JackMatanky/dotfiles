# espanso text expander: https://espanso.org/docs/
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./espanso-config.nix
    ./espanso-matches.nix
  ];

  services.espanso = {
    enable = true;
    package = pkgs.espanso;
  };
}
