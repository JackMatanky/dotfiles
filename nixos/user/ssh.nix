{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";
    compression = false;
    controlMaster = "no";
    # controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
    forwardAgent = false;
    hashKnownHosts = true;

    # extraOptionOverrides = {};
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
