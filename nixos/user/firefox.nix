{
  config,
  pkgs,
  # lib,
  # inputs,
  # systemSettings,
  # userSettings,
  ...
}: {
  # Firefox
  programs.firefox = {
    enable = true; # Install Firefox browser
  };
}
