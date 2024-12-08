{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ubuntu_font_family

    # Monospaced
    jetbrains-mono
    source-code-pro
    fira-code
    fira-code-nerdfont
    (nerdfonts.override {
      fonts = ["FiraCode" "JetBrainsMono"];
    })
    # Anki Fonts
    noto-fonts # multilingual support
    dejavu_fonts
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Ubuntu"];
      sansSerif = ["Ubuntu"];
      monospace = ["Fira Code"];
    };
  };
}
