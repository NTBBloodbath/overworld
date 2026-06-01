{
  config,
  lib,
  pkgs,
  ...
}: {
  # Extra hardware configurations
  #
  # Enable ryzen_smu kernel driver
  hardware.cpu.amd.ryzen-smu.enable = config.overworld.amd.enable;

  # Load amdgpu in stage1 — keeps GPU firmware out of userspace, avoids boot.mount I/O race
  hardware.amdgpu.initrd.enable = config.overworld.amd.enable;

  # Bootloader
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 3;
      };
    };
    initrd = {
      # Do the heavy lifting for the kernel
      systemd = {
        enable = true;
        tpm2.enable = false; # Nuke TPM, I don't use that bs
      };
      # Reduce size and modules
      compressor = lib.getExe pkgs.lz4;
      compressorArgs = [ "-l" ]; # -l = legacy frame format required by kernel; lz4 decompresses 3-4 GB/s vs zstd
      # NOTE: this does not seem to do lots of shit so I've disabled these
      includeDefaultModules = false;
      kernelModules = [ "nvme" "ext4" "vfat" ]; # vfat: avoids on-demand modprobe race when mounting /boot (EFI)
      availableKernelModules = [ "xhci_pci" "crc32c" ]; # stripped: usb_storage pulls Seagate spin-up into initrd (+5s)
    };
    plymouth.enable = false; # It just makes my boot time so fucking slow it makes me want to cry
    extraModulePackages = [] ++ (lib.optionals config.overworld.amd.enable [pkgs.linuxPackages_zen.zenpower]);
    kernelModules = [] ++ (lib.optionals config.overworld.amd.enable ["zenpower"]);
    # Blacklist TPM and serial ports + k10temp if AMD config module is enabled, temps are handled by zenpower
    blacklistedKernelModules = [ "tpm" "tpm_tis" "tpm_crb" "8250" "serial_core" "iwlwifi" ] ++ (lib.optionals config.overworld.amd.enable ["k10temp"]);
    kernelPackages = pkgs.linuxPackages_zen;
    # KERNEL PARAMETER                       | Parameter description
    # ---------------------------------------+---------------------------------------------------------------------------------------
    # rw                                     | Mounts root read/write
    # quiet                                  | Shut up Linux
    # rd.systemd.show_status=auto            | Shut up SystemD
    # splash                                 | Show a nice splash art while loading
    # sysrq_always_enabled=1                 | In case something freezes the system, makes the Magic Sysrq Key work
    # loglevel=3, rd.udev.log_priority=3     | Less logging
    # pcie_aspm=off                          | Nuke Active State Power Management, I don't need power-saving features
    # slab_nomerge                           | Improve kernel memory management speed and security by disabling merging of slabs of similar sizes
    # cpufreq.default_governor=performance   | Set CPU governor to performance
    # amdgpu.ppfeaturemask=0xffffffff        | Unlock access to overclocking my AMD GPU
    # amd_pstate=active                      | Enables the AMD cpu scaling, allowing my Ryzen to be more energy efficient
    # module_blacklist=8250,serial_core      | More aggressive blacklist for serial ports
    kernelParams =
      [
        "rw"
        "quiet"
        "splash"
        "rd.systemd.show_status=auto"
        "sysrq_always_enabled=1"
        "loglevel=3"
        "rd.udev.log_priority=3"
        "slab_nomerge"
        "pcie_aspm=off"
        "nvme_core.default_ps_max_latency_us=0"
        "nvme_core.admin_timeout=10"
        "pci=realloc,assign-busses"
        "module_blacklist=8250,serial_core,tpm,tpm_tis,tpm_crb"
        "tpm_tis.force=0"
        "8250.nr_uarts=0"
        # "cpufreq.default_governor=performance" # It seems like it is already the default in amd_pstate
      ]
      ++ (lib.optionals config.overworld.amd.enable [
        "amdgpu.ppfeaturemask=0xffffffff"
        "amd_pstate=active"
      ]);
  };

  # Disable systemd TPM for stage 2
  systemd.tpm2.enable = false;

  # Disable network wait service
  systemd.services.NetworkManager-wait-online.enable = false;

  fileSystems = lib.mkIf (!config.overworld.macbook.enable) {
    "/mnt/Juegos" = {
      device = "/dev/disk/by-label/Juegos";
      fsType = "ext4";
      options = ["nofail" "noauto" "x-systemd.device-timeout=5" "x-systemd.automount" "rw" "user" "exec" "relatime" "data=writeback" "nobh"];
    };
    "/mnt/Storage" = {
      device = "/dev/disk/by-label/STORAGE";
      fsType = "vfat";
      options = ["nofail" "noauto" "x-systemd.device-timeout=5" "x-systemd.automount" "rw" "user" "uid=1000" "gid=100" "exec" "relatime"];
      noCheck = true;
    };
  };

  # Configure console (TTY) keymap
  #
  # Using Xkb config is easier for macbok layout, and my desktop uses a latam spanish layout
  console = {
    useXkbConfig = config.overworld.macbook.enable;
    keyMap = lib.mkIf (!config.overworld.macbook.enable) "la-latin1";
  };

  # Enable ZRAM
  zramSwap.enable = true;

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
