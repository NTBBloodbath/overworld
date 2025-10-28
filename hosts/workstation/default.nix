{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    # Enable conditional configurations
    overworld = {
      amd.enable = true;
      gaming.enable = true;
      mpd.enable = true;
      lact.enable = true;
      cloudflare.enable = true;
      bluetoothOnBoot.enable = true;
    };

    # Enable OpenGL and hardware accelerated graphics drivers
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        libva
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
        rocmPackages.clr.icd
      ];
    };

    # System hostname
    networking.hostName = "tundra";

    # $HOME management
    hjem.users.amartin.files = {
      # Configuration files
      ".config/autostart".source = ../../etc/autostart;
      # ".config/beets".source = ../../etc/beets;
      ".config/DankMaterialShell".source = ../../etc/DankMaterialShell;
      ".config/fastfetch".source = ../../etc/fastfetch;
      ".config/fish".source = ../../etc/fish;
      ".config/ghostty".source = ../../etc/ghostty;
      ".config/git".source = ../../etc/git;
      ".config/jj".source = ../../etc/jj;
      ".config/MangoHud".source = ../../etc/MangoHud;
      ".config/mpv".source = ../../etc/mpv;
      ".config/niri".source = ../../etc/niri;
      ".config/rmpc".source = ../../etc/rmpc;
      ".config/systemd".source = ../../etc/systemd;

      # Bin scripts
      ".local/bin/set_gtk_theme.sh" = {
        source = ../../bin/set_gtk_theme.sh;
        executable = true;
      };

      # Share files
      ".local/share/fonts".source = ../../share/fonts;
    };
  };
}
