{
  config,
  lib,
  pkgs,
  ...
}: let
  mpdPackages = with pkgs; [
    beets
    # So that tools like Playerctl are able to interact with MPD
    mpdris2 # MPRIS 2 support for mpd
    # Terminal music player
    rmpc
    cava
  ];
in {
  environment.systemPackages =
    []
    ++ (lib.optionals config.overworld.mpd.enable mpdPackages)
    ++ (lib.optionals config.overworld.lact.enable [pkgs.lact]);

  # NOTE: see https://github.com/NixOS/nixpkgs/issues/317544 for information about the custom service
  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
      Nice = -10;
    };
    enable = config.overworld.lact.enable;
  };

  # Sound services
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # FS trim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Nautilus trash and VFS
  services.gvfs.enable = true;
  # Mount external drives in Nautilus sidebar
  services.udisks2.enable = true;

  # Resolved for OpenVPN
  services.resolved.enable = true;

  # Cloudflare WARP
  services.cloudflare-warp.enable = config.overworld.cloudflare.enable;

  # Jellyfin
  services.jellyfin = {
    enable = config.overworld.jellyfin.enable;
    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };
    openFirewall = true;
  };

  # MPD service
  services.mpd = {
    enable = config.overworld.mpd.enable;
    startWhenNeeded = false;

    user = "amartin";
    openFirewall = true;

    settings = {
      bind_to_address = "any";
      music_directory = "/mnt/Storage/Music";
      playlist_directory = "/mnt/Storage/Playlists";
      db_file = "/home/amartin/.local/share/mpd/database";
      audio_output = [
        {
          type = "fifo";
          name = "mpd_fifo";
          path = "/tmp/mpd.fifo";
          format = "44100:16:2";
        }
        {
          type = "httpd";
          name = "HTTP Stream";
          encoder = "lame";
          port = "8006";
          bitrate = "128000";
          format = "44100:16:2";
        }
        {
          type = "pipewire";
          name = "Pipewire Output";
        }
      ];
    };
  };

  # See https://wiki.nixos.org/wiki/MPD PipeWire workaround section
  systemd.services.mpd = {
    # Delay MPD so that it does not mount my /mnt/Storage during boot
    # since fsck on vFAT partitions makes my boot time slow as hell
    # wantedBy = [ "graphical.target" ];
    # after = [ "graphical.target" "network.target" "sound.target" ];
    environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };

  # Fan control
  services.thinkfan = {
    enable = config.overworld.tp.enable;
    # Slightly more aggressive than NixOS defaults:
    #   - 0-52C at lowest speed, quiet idle. Ramping begins ~47C.
    #   - All 8 levels instead of 5 levels. Smoother, gradual increase = less stress, cooler than default early on.
    #   - Each band overlaps ~3-4C. Strong hysteresis, few transitions. Good fan lifespan.
    #   - 67-85C for max. Stil reaches full speed well before thermal throttling. Temps stay low under load.
    #   - "level auto" 80 32767 keep as ceiling safety net.
    #
    # See: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/thinkfan.nix
    levels = [
      [ 0 0 52 ]
      [ 1 47 56 ]
      [ 2 50 58 ]
      [ 3 54 62 ]
      [ 4 57 65 ]
      [ 5 60 68 ]
      [ 6 63 73 ]
      [ 7 67 85 ]
      [ "level auto" 80 32767 ]
    ];
  };

  # Touchpad (enabled default in most desktopManager)
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      clickMethod = "clickfinger";
    };
  };

  # Prevent overheating
  services.thermald.enable = config.overworld.tp.enable;

  # Power management
  services.power-profiles-daemon.enable =
    if config.overworld.tp.enable
    then false
    else true;
  services.upower.enable = config.overworld.tp.enable;
  services.tlp = {
    enable = config.overworld.tp.enable;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      # Helps save long term battery health
      START_CHARGE_TRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
}
