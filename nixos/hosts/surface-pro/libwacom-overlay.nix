{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Overlay for libwacom, if needed for Surface pen support
  # nixpkgs.overlays = [
  #   (self: super: {
  #     libwacom = self.callPackage (self.path + "/pkgs/development/libraries/libwacom/surface.nix") {
  #       inherit (super) libwacom;
  #     };
  #   })
  # ];
}
