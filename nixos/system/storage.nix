# NixOS Wiki: Storage Optimization
# https://nixos.wiki/wiki/Storage_optimization
{
  config,
  pkgs,
  ...
}: {
  # Enable automatic garbage collection and nix store optimizltion
  nix = {
    gc = {
      automatic = true;
      dates = "weekly"; # Frequency can be "daily", "weekly", or "monthly"
      options = "--delete-older-than 30d"; # Optional: custom age limit for keeping generations (e.g., 30 days)
    };
    optimise = {
      automatic = true;
      dates = ["48hr"];
    };
  };
  # Retain only the last 5 system generations
  # system.autoUpgrade.keepBoot = 5;
}
