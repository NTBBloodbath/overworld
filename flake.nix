{
  description = "Goofy ahh system configuration";

  inputs = {
    # Nixpkgs - stable is only for bottles since these fuckers keep pushing broken stuff
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=26.05";

    # NixOS hardware configurations
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";

    # Playit.gg agent
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";

    # Neovim nightly
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Norgolith
    norgolith = {
      url = "github:norgolith/core";
    };

    # Hjem
    hjem.url = "github:feel-co/hjem";

    # Niri
    niri-git = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # System monitor for DankMaterialShell
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Phoenix for Firefox
    phoenix = {
      url = "git+https://codeberg.org/celenity/Phoenix?ref=pages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SpotX-Bash overlay
    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Serena MCP
    serena = {
      url = "github:oraios/serena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    nixos-hardware,
    playit-nixos-module,
    neovim-nightly-overlay,
    norgolith,
    hjem,
    niri-git,
    quickshell,
    dank-material-shell,
    dgop,
    phoenix,
    oskars-dotfiles,
    serena,
    zen-browser,
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
          hjem.nixosModules.default
          phoenix.nixosModules.default
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
          ./hosts/macbook
          nixos-hardware.nixosModules.apple-macbook-pro-11-4
          hjem.nixosModules.default
          phoenix.nixosModules.default
        ];
      };
    };
  };

  # Binary cache to improve the build time of playit
  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [ "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4=" ];
  };
}
