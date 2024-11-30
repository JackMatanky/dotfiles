# NixOS Wiki: Storage Optimization
# https://nixos.wiki/wiki/Storage_optimization
{
  config,
  pkgs,
  ...
}: {
  nix = {
    # Automatic Garbage Collection
    gc = {
      automatic = true;
      dates = "weekly"; # Frequency: "daily", "weekly", "monthly"
      options = "--delete-older-than 30d"; # Custom age limit for keeping generations
    };
    # Nix Store Optimizltion
    optimise = {
      automatic = true;
      dates = ["48hr"];
    };
  };
  # Previous system generations to retain
  # system.autoUpgrade.keepBoot = 5;
}
