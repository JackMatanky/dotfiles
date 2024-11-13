{
  description = "JackMatanky Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # Use the option below until kernel 6.11.5
    nixos-hardware.url = "github:nixos/nixos-hardware/feefc78";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snippets language server for Zed
    # https://github.com/estin/simple-completion-language-server
    # simple-completion-language-server = {
    #   url = "github:estin/simple-completion-language-server";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    ...
  } @ inputs: let
    userSettings = rec {
      username = "jack";
      firstName = "Jack";
      lastName = "Matanky";
      fullName = "${firstName} ${lastName}";
      email = "JackMatanky@gmail.com";
      dotfilesDir = "~/.dotfiles"; # local repo absolute path
    };
    systemSettings = rec {
      system = "x86_64-linux";
      device = "SurfacePro";
      hostName = "${userSettings.username}${device}";
      profile = "personal";
      timeZone = "Asia/Jerusalem";
      locale = "en_IL"; # "he_IL.UTF-8";
      # bootMode = "uefi"; # uefi or bios
      # bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      # grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      # gpuType = "amd"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
    };
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${systemSettings.system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};
    # linuxSurfaceRepo = pkgs.fetchFromGitHub {
    #   owner = "linux-surface";
    #   repo = "linux-surface";
    #   rev = "260b202ade51ae01f4bf5f4a5516559bd5f04973";
    #   sha256 = "sha256-DmYbfi7scxWDHlqZA7ZidCnpMexC34+T4DA7yTs5GAI=";
    # };
  in {
    nixosConfigurations = {
      jackSurfacePro = lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          nixos-hardware.nixosModules.microsoft-surface-common
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          home-manager.nixosModules.default
          ./hardware-configuration.nix
          ./configuration.nix
          # ./hosts/surface-pro/surface-pkgs.nix
          # (import ./hosts/surface-pro/surface-kernel.nix {
          #   inherit lib pkgs linuxSurfaceRepo;
          # })
        ];
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

    homeConfigurations = {
      jack = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs-unstable;
        };
      };
    };
    # formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
