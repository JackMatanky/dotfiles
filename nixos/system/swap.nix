# Bootloader configuration for UEFI systems.
{
  config,
  pkgs,
  ...
}: let
  mibPerGib = 1024; # Define MiB per GiB
in {
  imports = [
    ../modules/swap.nix
  ];

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
