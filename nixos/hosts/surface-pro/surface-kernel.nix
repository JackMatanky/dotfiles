# Source - dotlambda: https://github.com/NixOS/nixpkgs/issues/240612#issuecomment-1635859341
{
  lib,
  pkgs,
  linuxSurfaceRepo,
  ...
}: let
  # Determine the latest kernel version available in the linux-surface repo
  kernelVersion =
    lib.foldl
    (v1: v2:
      if lib.versionAtLeast v1 v2
      then v1
      else v2)
    "0.0"
    (lib.attrNames (lib.filterAttrs (n: v: v == "directory") (
      builtins.readDir "${linuxSurfaceRepo}/patches"
    )));
in {
  # Use lib.mkForce to ensure that the kernel packages are set correctly
  boot.kernelPackages = lib.mkForce pkgs.${"linuxPackages_" + lib.replaceStrings ["."] ["_"] kernelVersion};

  # Add patches from the linux-surface repository to the kernel
  boot.kernelPatches =
    [
      {
        name = "linux-surface-config";
        patch = null;
        extraStructuredConfig = with lib.kernel; {
          STAGING_MEDIA = yes;
          FUNCTION_ERROR_INJECTION = yes;
        };
        extraConfig = lib.replaceStrings ["CONFIG_" "="] ["" " "] (lib.readFile "${linuxSurfaceRepo}/configs/surface-${kernelVersion}.config");
      }
    ]
    ++ map (pname: {
      name = "linux-surface-${pname}";
      patch = "${linuxSurfaceRepo}/patches/${kernelVersion}/${pname}.patch";
    }) [
      "0001-secureboot"
      "0002-surface3-oemb"
      "0003-mwifiex"
      "0004-ath10k"
      "0005-ipts"
      "0006-ithc"
      "0007-surface-sam"
      "0008-surface-sam-over-hid"
      "0009-surface-button"
      "0010-surface-typecover"
      "0011-surface-shutdown"
      "0012-surface-gpe"
      "0013-cameras"
      "0014-amd-gpio"
      "0015-rtc"
    ];

  # Additional configuration for Surface hardware
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Add necessary packages and groups for Surface device compatibility
  environment.systemPackages = with pkgs; [surface-control];
  users.groups.surface-control = {};
  services.udev.packages = [
    pkgs.iptsd
    pkgs.surface-control
  ];
  systemd.packages = [
    pkgs.iptsd
  ];

  # Overlay for libwacom, if needed for Surface pen support
  nixpkgs.overlays = [
    (self: super: {
      libwacom = self.callPackage (self.path + "/pkgs/development/libraries/libwacom/surface.nix") {
        inherit (super) libwacom;
      };
    })
  ];
}
