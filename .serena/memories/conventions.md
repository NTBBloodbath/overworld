# Conventions

## Nix style
- Standard NixOS module function args pattern: `{ config, lib, pkgs, inputs, ... }: { ... }`. Order/which args vary per module; include only what's used.
- `let ... in` used for local derivation helpers (see `modules/editor.nix`, `modules/services.nix`).
- Feature gating: use `options.overworld.<feature>.enable` (defined in `modules/options.nix` via `lib.mkEnableOption`) + `config.overworld.<feature>.enable` conditionals, or `lib.mkIf` for whole-config blocks. Never hardcode host checks in modules.
- `lib.optionals <cond> [ ... ]` for conditional list elements.
- Module args that receive `inputs` must declare it (`{ pkgs, inputs, ... }`) to use flake inputs.
- Hosts receive `specialArgs = { inherit inputs; }` from flake.
- Comment style: colloquial, sometimes profane one-liners explaining *why* (`# Electron shitfest`, `# Nuke TPM`). Keep the spirit; explanations over restatement.

## System packages
- Global/essential packages in `hosts/default.nix` `environment.systemPackages`.
- Feature-specific packages: in the module owning the feature (e.g. gaming packages in `modules/gaming.nix`, mpd tools in `modules/services.nix`), gated by the matching `overworld.*` option.
- User-only apps (IDE, slack, spotify, zen-browser) go in `users.users.amartin.packages` in `modules/users.nix`.

## Home config files
- App config lives in `etc/<app>/...`, wired to `~/.config` through `hjem.users.amartin.files` in each host's `hosts/<host>/default.nix` (e.g. `.config/niri.source = ../../etc/niri`).
- Both hosts have a `hardware-configuration.nix`; keep machine-generated files untouched.
- Fish config in `etc/fish` is currently NOT wired to hjem (commented out) — don't re-enable without intent.
