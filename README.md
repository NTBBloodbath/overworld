# Overworld

A wise man once said "never say never", but the fool didn't understand and went on his way.
Later, the fool discovered his enormous masochism by tripping over the stone he always said he would
never trip over. And that's how I ended up becoming a NixOS user.

> [!NOTE]
> The name of my dotfiles comes from both the [Minecraft Tundra biome](https://minecraft.wiki/w/Tundra) and the [Minecraft Taiga biome](https://minecraft.wiki/w/Taiga). The repository name is a reference to the Minecraft overworld.

---

For the time being, I continue to configure my software in the traditional way. Those configurations
reside in the `etc` directory, and my NixOS configuration resides in the `modules` directory, while
the host specific (and common/shared) configurations reside in the `hosts` directory. Both `bin`
and `share` directories are self-explanatory.

## Installation

Pre-requisites:
- [NixOS](https://nixos.org/manual/nixos/stable/index.html#ch-installation) installed.
- [Flakes enabled](https://nixos.wiki/wiki/flakes).

Clone the repository and `cd` into it:
```sh
git clone https://github.com/NTBBloodbath/overworld.git && cd overworld
```

First, create a hardware configuration for your system:
```sh
sudo nixos-generate-config
```

After you have created a `/etc/nixos/hardware-configuration.nix` file, copy it to the repository and
then proceed to build the configuration with:
```sh
# Change workstation to whatever you want if you are using my setup
# if you do, remember to also modify the module import path in the flake.nix
cp /etc/nixos/hardware-configuration.nix ./hosts/workstation/

sudo nixos-rebuild switch --flake .#workstation
```

Currently, there are two available hosts on my flake system configurations, which are the following:
- `taiga` - Macbook pro 11,4
- `tundra` - Desktop workstation

> [!IMPORTANT]
>
> After the initial setup, `nh os switch ~/overworld` is the recommended way to rebuild the system instead of `nixos-rebuild switch`. No `sudo` required.

Once everything is ready, move the contents of the `etc` directory to `~/.config`, the `share`
directory to `~/.local/share` and the `bin` directory to `~/.local/bin`.

Additionally, for my Niri setup one must follow the [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) installation instructions. Which is basically cloning the repository, downloading [dgop](https://github.com/AvengeMedia/dgop) to `~/.local/bin`, then calling it a day.

## Showcase

<details>
<summary>Desktop view</summary>

  <img width="1920" height="1080" alt="Desktop with fastfetch and cava" src="https://github.com/user-attachments/assets/dad04ea9-4d14-4a0d-aa5a-25bc7a0c1f2d" />

  <img width="1920" height="1080" alt="Overview" src="https://github.com/user-attachments/assets/61fd3c02-3581-4273-a88e-bdd8c66b89ba" />

</details>

## License

My dotfiles are licensed under the ~cuck~ MIT license. Feel free to take inspiration or take parts
from them.
