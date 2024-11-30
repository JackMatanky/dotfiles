# Bootloader configuration for UEFI systems.
{
  config,
  pkgs,
  ...
}: {
  boot = {
    enableSwapDevices = true; # Enable swap devices (optional)
    swapDevices = [
      {
        device = "/swapfile";
        # Size will be automatically calculated by the module
      }
    ];
  };
}
