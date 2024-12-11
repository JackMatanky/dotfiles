# Espanso Text Expander: https://espanso.org/docs/
# Espanso Matches: https://espanso.org/docs/matches/basics/
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.espanso.configs = {
    default = {
      show_notifications = true;
    };
    # vscode = {
    #   filter_title = "Visual Studio Code$";
    #   backend = "Clipboard";
    # };
  };
}
