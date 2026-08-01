# Overworld — NixOS dotfiles flake

NixOS system configuration (dotfiles) managed as a flake. Layout:

- `flake.nix` — inputs (nixpkgs unstable+stable, nixos-hardware, hjem, niri-git, quickshell, dank-material-shell, serena, norgolith, zen-browser, ...) and two `nixosConfigurations`: `tundra` (workstation, AMD) and `taiga` (Macbook pro 11,4).
- `hosts/` — per-host config. `hosts/default.nix` = shared config (locale, fish, packages, hjem user). `hosts/<host>/default.nix` imports hardware-configuration.nix, sets `overworld.<feature>.enable` flags, hostname, and wires `etc/`/`bin/`/`share/` into hjem files.
- `modules/` — shared NixOS modules, all imported by `modules/default.nix`. Feature toggles declared in `modules/options.nix` under `options.overworld.*` (amd, macbook, gaming, mpd, lact, cloudflare, jellyfin, bluetoothOnBoot).
- `etc/` — plain config files mirrored into `~/.config` via hjem (per-host selection in hosts/*/default.nix). Subdirs mirror app names (niri, fish, ghostty, git, jj, rmpc, systemd, ...). Some commented-out in hjem, e.g. `.config/fish` is disabled.
- `bin/` — personal scripts → `~/.local/bin`.
- `share/` — fonts, wallpapers → `~/.local/share`.

Key notes:
- `nixpkgs.overlays` defined in `hosts/default.nix` (openldap check workaround) and `modules/editor.nix` (neovim stable/nightly wrappers).
- AMD-specific kernel/boot params gated behind `overworld.amd.enable` in `modules/boot.nix`.
- MPD music dir `/mnt/Storage/Music`; mounts `/mnt/Juegos` + `/mnt/Storage` auto-mounted, non-macbook only.
- Two `hardware-configuration.nix` files (one per host) are machine-generated, keep them synced from the live system.
- User is `amartin` (Alejandro Martin), host `tundra`/`taiga`.
