# {
#   config,
#   pkgs,
#   ...
# }: {
#   programs.gnome-settings-daemon.enable = true;
#
#   programs.gnome-shell.enable = true;
#   programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
#     gnome-shell-extension-appindicator
#   ];
#
#   programs.gnome-shell.excludePackages = with pkgs.gnome;
#     [
#       epiphany
#       simple-scan
#       totem
#       yelp
#       gnome-font-viewer
#       gnome-maps
#       gnome-music
#     ]
#     ++ (with pkgs; [
#       gedit
#       gnome-connections
#       gnome-text-editor
#       gnome-tour
#       yelp
#     ]);
# }
