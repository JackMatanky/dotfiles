{
  config,
  pkgs,
  # lib,
  # inputs,
  # systemSettings,
  # userSettings,
  ...
}: {
  imports = [
    ./fonts.nix
    ./gnome-pkgs-exclude.nix
    ./locale.nix
    ./storage.nix
  ];
}
