{
  config,
  pkgs,
  # pkgs-unstable,
  # userSettings,
  ...
}: let
  cliDir = builtins.path {
    path = ../../cli;
    name = "cli";
  };
in {
  home = {
    packages = with pkgs; [
      anki-bin
    ];

    file = {
      ".local/share/Anki2/addons21/".source = "";
      # ".local/share/Anki2/addons21/AnkiConnect".source = pkgs.fetchFromGitHub {
      #   owner = "FooSoft";
      #   repo = "anki-connect";
      #   rev = "v6.1.0"; # Use the desired tag or commit hash
      #   sha256 = "sha256-..."; # Calculate the SHA256 hash
      # };
    };
  };
}
