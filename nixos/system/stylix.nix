{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    # OR

    # stylix.base16Scheme = {
    #   base00 = "282828";
    #   base01 = "3c3836";
    #   base02 = "504945";
    #   base03 = "665c54";
    #   base04 = "bdae93";
    #   base05 = "d5c4a1";
    #   base06 = "ebdbb2";
    #   base07 = "fbf1c7";
    #   base08 = "fb4934";
    #   base09 = "fe8019";
    #   base0A = "fabd2f";
    #   base0B = "b8bb26";
    #   base0C = "8ec07c";
    #   base0D = "83a598";
    #   base0E = "d3869b";
    #   base0F = "d65d0e";
    # };

    # Don't forget to apply wallpaper

    image = ../../assets/background_desktop_cloud_lake_winter_fantasy.jpg;

    fonts.sizes = {
      applications = 12;
      terminal = 15;
      desktop = 10;
      popups = 10;
    };

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      desktop = 1.0;
      popups = 1.0;
    };

    polarity = "dark"; # "light" or "either"

    # cursor.package = pkgs.bibata-cursors;
    #   stylix.cursor.name = "Bibata-Modern-Ice";

    #   fonts = {
    #     monospace = {
    #       package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    #       name = "JetBrainsMono Nerd Font Mono";
    #     };
    #     sansSerif = {
    #       package = pkgs.dejavu_fonts;
    #       name = "DejaVu Sans";
    #     };
    #     serif = {
    #       package = pkgs.dejavu_fonts;
    #       name = "DejaVu Serif";
    #     };
    #   };
  };
}
