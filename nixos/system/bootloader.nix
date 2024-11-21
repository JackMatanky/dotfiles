# Bootloader configuration for UEFI systems.
{
  config,
  pkgs,
  ...
}: {
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    # grub = {
    #   enable = true;
    #   device = "/dev/vda";
    #   useOSProber = true;
    # };
  };
}
