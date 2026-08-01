# Suggested commands

Formatting:
- `alejandra .` — format all Nix files (repo formatter).

Rebuild / apply system config (from anywhere):
- `nh os switch ~/overworld --cores 6 --max-jobs 12` — rebuild active host, no sudo (recommended). Always pass the perf flags.
- `nh os build ~/overworld --cores 6 --max-jobs 12` — build without switching.
- `nixos-rebuild switch --flake .#<host>` — host = `tundra` or `taiga` (needs sudo).
- `sudo nixos-generate-config` — regenerate hardware-configuration.nix; copy to `hosts/<host>/`.

Flake hygiene:
- `nix flake update` — bump all inputs.
- `nix flake check` — validate flake outputs.
- `nix run .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath` — not needed; use nh.

VCS (jujutsu over git backend):
- `jj log`, `jj status`, `jj describe`, `jj new` — normal jj workflow.
- `jj git push` — push to origin (git remote).

Misc (Linux, no shell differences; standard commands behave normally):
- `nh os switch --update` — update flake.lock then switch.
