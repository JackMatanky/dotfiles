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
    enableSwapDevices = true; # Enable swap devices (optional)
    swapDevices = [
      {
        device = "/swapfile";
        # Size will be automatically calculated by the module
      }
    ];
  };
}
