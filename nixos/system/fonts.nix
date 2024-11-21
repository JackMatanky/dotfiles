{
  config,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    ubuntu_font_family

    # Monospaced
    jetbrains-mono
    source-code-pro
    fira-code
    (nerdfonts.override {
      fonts = ["FiraCode"];
    })
    # Anki Fonts
    noto-fonts
    dejavu_fonts
  ];
}
