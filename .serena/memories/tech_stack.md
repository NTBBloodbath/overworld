# Tech stack

- Language: Nix (NixOS module system, flakes).
- Nixpkgs: `nixos-unstable` (main), `nixpkgs-stable` (ref `26.05`, only for bottles).
- Build tool: Flakes. Inputs pinned in `flake.lock`.
- Home/user file management: [hjem](https://github.com/feel-co/hjem) (module `hjem.nixosModules.default`), not home-manager. Config in `hosts/default.nix` (`hjem.users.amartin`) + per-host file wiring.
- WM/compositor: niri (Wayland) + greetd autologin + DankMaterialShell (quickshell).
- Formatter: alejandra (system package).
- System rebuild: `nh os switch` (nh = nix helper, `programs.nh.enable`).
- VCS: jujutsu (`jj`) with git backend; repo also contains `.git`.
