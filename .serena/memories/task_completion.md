# Task completion

Before calling a coding task done, run:

1. `alejandra .` — format all Nix files (must be clean; it's also the only "linter" for this repo).
2. `nix flake check` — validate flake (may be slow; skip if only `etc/` non-Nix files changed).
3. `nh os build ~/overworld --cores 6 --max-jobs 12` (or `nixos-rebuild build --flake .#tundra`) — compile the system config; catches module option errors. Rebuild takes a while; run only if Nix module changes were made.
4. `jj status` — verify only intended files changed; stage/describe via jj workflow.

No test suite exists. `nix flake check` is the closest thing to CI.
