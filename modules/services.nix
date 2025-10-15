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

  # Cloudflare WARP
  services.cloudflare-warp.enable = config.overworld.cloudflare.enable;

  # MPD service
  services.mpd = {
    enable = config.overworld.mpd.enable;
    startWhenNeeded = true;

    user = "amartin";

    musicDirectory = "/mnt/Storage/Music";
    playlistDirectory = "/mnt/Storage/Playlists";
    network.listenAddress = "any";

    extraConfig = ''
      # Cava visualizer
      audio_output {
        type   "fifo"
        name   "mpd_fifo"
        path   "/tmp/mpd.fifo"
        format "44100:16:2"
      }

      # HTTP Streaming (MAFA)
      audio_output {
        type "httpd"
        name "HTTP Stream"
        encoder "lame" # optional
        port "8006"
        bitrate "128000"
        format "44100:16:2"
      }

      audio_output {
        type "pipewire"
        name "Pipewire Output"
      }
    '';
  };

  # See https://wiki.nixos.org/wiki/MPD PipeWire workaround section
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # Macbook specific services
  #
  # Macbook webcam support
  hardware.facetimehd.enable = config.overworld.macbook.enable;

  # Fan control
  services.mbpfan = {
    enable = config.overworld.macbook.enable;
    aggressive = false;
    # Even more aggressive settings for the fan
    settings.general = {
      low_temp = 45;
      high_temp = 55;
      max_temp = 65;
    };
  };

  # Touchpad (enabled default in most desktopManager)
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Prevent overheating
  services.thermald.enable = config.overworld.macbook.enable;

  # Power management
  services.power-profiles-daemon.enable =
    if config.overworld.macbook.enable
    then false
    else true;
  services.tlp = {
    enable = config.overworld.macbook.enable;
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
