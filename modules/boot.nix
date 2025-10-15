{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Extra hardware configurations
  #
  # Enable ryzen_smu kernel driver
  hardware.cpu.amd.ryzen-smu.enable = config.overworld.amd.enable;

  # Load amdgpu in stage1, fixes lower resolution in boot screen
  # during the initramfs phase
  hardware.amdgpu.initrd.enable = config.overworld.amd.enable;

  # Bootloader
  boot = {
    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 3;
      };
    };
    initrd.systemd.enable = true; # Do the heavy lifting for the kernel
    plymouth.enable = false; # It just makes my boot time so fucking slow it makes me want to cry
    extraModulePackages = [] ++ (lib.optionals config.overworld.amd.enable [ pkgs.linuxPackages_xanmod_stable.zenpower ]);
    kernelModules = [] ++ (lib.optionals config.overworld.amd.enable [ "zenpower" ]);
    blacklistedKernelModules = [] ++ (lib.optionals config.overworld.amd.enable [ "k10temp" ]);
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    # KERNEL PARAMETER                       | Parameter description
    # ---------------------------------------+---------------------------------------------------------------------------------------
    # rw                                     | Mounts root read/write
    # quiet                                  | Shut up Linux
    # rd.systemd.show_status=auto            | Shut up SystemD
    # splash                                 | Show a nice splash art while loading
    # sysrq_always_enabled=1                 | In case something freezes the system, makes the Magic Sysrq Key work
    # cpufreq.default_governor=performance   | Set CPU governor to performance
    # amdgpu.ppfeaturemask=0xffffffff        | Unlock access to overclocking my AMD GPU
    # amd_pstate=active                      | Enables the AMD cpu scaling, allowing my Ryzen to be more energy efficient
    kernelParams = [
      "rw"
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "sysrq_always_enabled=1"
      # "cpufreq.default_governor=performance" # It seems like it is already the default in amd_pstate
    ]
    ++ (lib.optionals config.overworld.amd.enable [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amd_pstate=active"
    ]);
  };

  fileSystems = lib.mkIf (!config.overworld.macbook.enable) {
    "/mnt/Juegos" = {
      device = "/dev/disk/by-label/Juegos";
      fsType = "ext4";
      options = ["nofail" "x-systemd.device-timeout=5" "rw" "user" "exec" "relatime" "data=writeback" "nobh"];
    };
    "/mnt/Storage" = {
      device = "/dev/disk/by-label/STORAGE";
      fsType = "vfat";
      options = ["nofail" "x-systemd.device-timeout=5" "rw" "user" "uid=1000" "gid=100" "exec" "relatime"];
    };
  };

  # Configure console (TTY) keymap
  #
  # Using Xkb config is easier for macbok layout, and my desktop uses a latam spanish layout
  console = {
    useXkbConfig = config.overworld.macbook.enable;
    keyMap = lib.mkIf (!config.overworld.macbook.enable) "la-latin1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html)
  #
  # Also make sure to check https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
