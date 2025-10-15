{
  description = "Goofy ahh system configuration";

  inputs = {
    # Nixpkgs unstable
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # NixOS hardware configurations
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";

    # Playit.gg agent
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Norgolith
    norgolith.url = "github:NTBBloodbath/norgolith";

    # Quickshell nightly
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DankMaterialShell
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System monitor for DankMaterialShell
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SpotX-Bash overlay
    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    playit-nixos-module,
    neovim-nightly-overlay,
    norgolith,
    quickshell,
    dank-material-shell,
    dms-cli,
    dgop,
    oskars-dotfiles,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # Workstation
      tundra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts
          ./hosts/workstation
          playit-nixos-module.nixosModules.default
          # Spotify patched with SpotX-Bash
          ({pkgs, ...}: {
            nixpkgs.overlays = [oskars-dotfiles.overlays.spotx];
          })
        ];
      };
      # Macbook
      taiga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts
          ./hosts/workstation
          nixos-hardware.nixosModules.apple-macbook-pro-11-4
        ];
      };
    };
  };

  # Binary cache to improve the build time of playit
  nixConfig = {
    extra-substituters = ["https://playit-nixos-module.cachix.org"];
    extra-trusted-public-keys = ["playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="];
  };
}
