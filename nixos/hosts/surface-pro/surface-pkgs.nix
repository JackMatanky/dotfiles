# Surface Pro config for touchscreen and stylus support and power management
# SOURCE - NixOS: https://github.com/NixOS/nixos-hardware/tree/master/microsoft/surface
# SOURCE - Linux Surface Repo: https://github.com/linux-surface
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # The Surface Pro Intel module
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    # ./kernel.nix
  ];

  # Create a user group for managing permissions related to Surface hardware
  # users.groups.surface-control = {};

  # Additional configuration for Surface hardware
  # hardware.sensor.iio = {
  #   enable = lib.mkDefault true;
  # };

  # Install surface-control for managing Surface-specific hardware features
  # environment.systemPackages = with pkgs; [
  #   iptsd # touchscreen support
  #   surface-control # power management
  #   libwacom-surface
  # ];

  # Add iptsd and surface-control to the udev and systemd packages
  # services.udev.packages = with pkgs; [
  #   iptsd
  #   surface-control
  # ];

  # systemd.packages = [
  #   pkgs.iptsd
  # ];

  # Enable power management for Surface devices
  systemd.user.services.surface-control = {
    enable = true;
    description = "Surface Control Daemon";
    serviceConfig.ExecStart = "${pkgs.surface-control}/bin/surface-control";
    wantedBy = ["default.target"];
  };

  services.thermald = {
    enable = true;
  };

  # Enable touchscreen support
  services.iptsd = {
    enable = true;
    config = {
      Touchscreen = {
        DisableOnPalm = true;
        DisableOnStylus = true;
      };
      Stylus = {
        Disable = false;
      };
    };
  };
}