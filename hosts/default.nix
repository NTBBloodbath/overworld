{ lib, pkgs, ... }:

{
  imports = [
    ../modules
  ];

  # Timezone
  time.timeZone = "America/Caracas";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_VE.UTF-8";
      LC_IDENTIFICATION = "es_VE.UTF-8";
      LC_MEASUREMENT = "es_VE.UTF-8";
      LC_MONETARY = "es_VE.UTF-8";
      LC_NAME = "es_VE.UTF-8";
      LC_NUMERIC = "es_VE.UTF-8";
      LC_PAPER = "es_VE.UTF-8";
      LC_TELEPHONE = "es_VE.UTF-8";
      LC_TIME = "es_VE.UTF-8";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Android Debug Bridge
  programs.adb.enable = true;

  # Nix Helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
    flake = "/home/amartin/overworld";
  };

  # FISH shell
  programs.fish = {
    enable = true;
    shellAliases = lib.mkForce {}; # Get rid of these annoying default aliases
  };

  # Initialize FISH from BASH without replacing the default shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Enable direnv integration (+ nix-direnv)
  programs.direnv = {
    enable = true;
    silent = true; # direnv is way too verbose
    nix-direnv.enable = true;
  };

  # Firefox Developer Edition
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
  };

  # Common essential packages for all systems
  environment.systemPackages =
    (with pkgs; [
      # VCS
      git
      jujutsu
      # Archives
      zip
      unzip
      rar
      unrar
      p7zip
      # Terminal utilities
      jq
      fd
      zf
      eza
      fzf
      wget
      btop
      ripgrep
      tealdeer
      pciutils
      hyperfine
      lm_sensors
      smartmontools
      libnotify
      wl-clipboard
      # GUI applications
      ente-desktop
      mission-center
      # Office
      libreoffice
      hunspell
      hunspellDicts.es_VE
      hunspellDicts.en-gb-ize
      # Misc
      fastfetch
    ])
    ++ (with pkgs.fishPlugins; [
      fzf
      bass
      done
      sponge
      autopair
      async-prompt
      colored-man-pages
    ]);

  nix = {
    # Automatically run the Nix store optimiser by using a systemd timer
    optimise.automatic = true;

    settings = {
      # Deduplicate and optimize storage
      # You can also manually optimize the store via:
      #    nix-store --optimise
      # Refer to the following link for more details:
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      # Set up Nix experimental features
      experimental-features = ["nix-command" "flakes"];
    };

    # So that devenv can handle the caching for me
    extraOptions = ''
      trusted-users = root amartin
    '';
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # ...
      #
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      #
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };
}
