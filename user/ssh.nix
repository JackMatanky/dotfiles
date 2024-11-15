{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # GitHub SSH config
      Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes

      # GitLab SSH config
      Host gitlab.com
          HostName gitlab.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
    '';
  };
}
