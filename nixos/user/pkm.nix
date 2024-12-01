{
  config,
  pkgs,
  # pkgs-unstable,
  # userSettings,
  ...
}: let
  ankiDir = builtins.path {
    path = ../../anki;
    name = "anki";
  };
in {
  home = {
    packages = with pkgs; [
      anki-bin # Flashcard program
      ffmpeg # Video/audio processing (dependency for Anki)

      obsidian # Markdown-based knowledge management

      xournalpp # Handwriting annotation software

      zotero # Reference manager
    ];

    file = {
      ".local/share/Anki2".source = ankiDir;
      # ".local/share/Anki2/addons21/AnkiConnect".source = pkgs.fetchFromGitHub {
      #   owner = "FooSoft";
      #   repo = "anki-connect";
      #   rev = "v6.1.0"; # Use the desired tag or commit hash
      #   sha256 = "sha256-..."; # Calculate the SHA256 hash
      # };
    };
  };

  # https://mynixos.com/home-manager/options/programs.mpv
  programs.mpv = {
    enable = true;
  };
}
