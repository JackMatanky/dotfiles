{
  config,
  pkgs,
  # lib,
  # inputs,
  # systemSettings,
  # userSettings,
  ...
}: {
  # Exclude Core Apps From Being Installed.
  environment.gnome.excludePackages =
    (with pkgs.gnome; [
      epiphany # web browser
      simple-scan # document scanner
      totem # video player
      yelp # help viewer
      gnome-font-viewer
      gnome-maps # maps
      gnome-music # music
    ])
    ++ (with pkgs; [
      gedit # text editor
      gnome-connections
      gnome-text-editor
      gnome-tour # tour app
      nautilus # File Manager
      yelp # help viewer
    ]);
}
# All pre-installed Gnome packages
# pkgs.adwaita-icon-theme
# pkgs.evince # document viewer
# pkgs.file-roller # archive manager
# pkgs.geary # mail
#
# pkgs.gnome-backgrounds
# pkgs.gnome-calendar
# pkgs.gnome-calculator
# pkgs.gnome-characters
# pkgs.gnome-clocks
# pkgs.gnome-console
# pkgs.gnome-contacts
# pkgs.gnome-logs
# pkgs.gnome-maps
# pkgs.gnome-system-monitor
# pkgs.gnome-themes-extra
# pkgs.gnome-user-docs
# pkgs.gnome-weather
# pkgs.nautilus
# pkgs.orca
# pkgs.sushi
# pkgs.baobab
# pkgs.loupe
# pkgs.snapshot
# ];

