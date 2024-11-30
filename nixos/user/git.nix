{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "${userSettings.firstName}${userSettings.lastName}";
    userEmail = userSettings.email;
    aliases = {
      st = "status";
      cm = "commit -m";
      pl = "pull";
    };
    attributes = [
      "*.pdf diff=pdf"
      "*.gif binary"
      "*.jpg binary"
      "*.png binary"
      "*.webp binary"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "false";
      core = {
        autocrlf = "input";
        eol = "lf";
      };
    };
  };
}
