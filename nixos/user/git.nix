{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  home.file = {
    ".gitconfig".source = ../../git/.gitconfig; # Manage .gitconfig declaratively
    ".gitattributes".source = ../../git/.gitattributes; # Manage .gitattributes declaratively
  };

  programs.git = {
    enable = true;
    extraConfig = {
      include.path = "${config.home.homeDirectory}/.dotfiles/git/.gitconfig";
    };
    # enable = true;
    # userName = "${userSettings.firstName}${userSettings.lastName}";
    # userEmail = userSettings.email;
    # aliases = {
    #   st = "status";
    #   cm = "commit -m";
    #   pl = "pull";
    # };
    # attributes = [
    #   "*.pdf diff=pdf"
    #   "*.gif binary"
    #   "*.jpg binary"
    #   "*.png binary"
    #   "*.webp binary"
    # ];
    # extraConfig = {
    #   init.defaultBranch = "main";
    #   pull.rebase = "false";
    #   core = {
    #     autocrlf = "input";
    #     eol = "lf";
    #   };
    # };
  };
}
