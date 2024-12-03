# modules/swap.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  mibPerGib = 1024; # Define MiB per GiB

  # Function to get total RAM in MiB
  getTotalRamMib = pkgs.systemd.ramInBytes / mibPerGib / mibPerGib;

  # Function to get free disk space in MiB
  getFreeDiskSpace = path: let
    stat = builtins.fromJSON (pkgs.coreutils.df "-BM" "--output=avail" path);
  in
    lib.toInt (builtins.head (builtins.attrValues stat));

  # Calculate swap file size based on free disk space and total RAM
  swapFileSize = let
    freeDisk = getFreeDiskSpace "/";
    totalRam = getTotalRamMib;
  in
    if freeDisk > 2 * totalRam
    then totalRam * 2
    else
      (
        if freeDisk > 1.5 * totalRam
        then totalRam * 1.5
        else
          (
            if freeDisk > totalRam
            then totalRam
            else totalRam * 0.5
          )
      );
in {
  options = {
    boot.swapDevices = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [
        {
          device = "/swapfile";
          size = swapFileSize;
        }
      ];
      description = "Swap file configuration.";
    };
    # Hypothetical option to enable/disable swap
    boot.enableSwapDevices = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable swap devices.";
    };
  };
  config = lib.mkIf config.boot.enableSwapDevices {
    # Debug traces
    _debug_totalRamMib = builtins.trace "Total RAM in MiB: ${getTotalRamMib}" getTotalRamMib;
    _debug_freeDisk = builtins.trace "Free disk space in MiB: ${getFreeDiskSpace "/"}" (getFreeDiskSpace "/");
    _debug_swapFileSize = builtins.trace "Calculated swap file size in MiB: ${swapFileSize}" swapFileSize;
    # Apply swap-related configuration only if swapDevices is enabled
    boot.swapDevices = config.boot.swapDevices;
    # ... other potential swap-related configuration ...
  };
}
