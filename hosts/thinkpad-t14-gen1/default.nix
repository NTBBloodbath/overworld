{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    # Enable conditional configurations
    overworld = {
      tp.enable = true;
      gaming = {
        enable = true;
        diablo.enable = true;
        minecraft.enable = true;
      };
    };

    # Enable OpenGL and hardware accelerated graphics drivers
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.mesa ];
    };

    # System hostname
    networking.hostName = "taiga";

    # $HOME management
    hjem.users.amartin.files = {
      # Configuration files
      ".config/beets/config.yaml".source = ../../etc/beets/config.yaml;
      ".config/DankMaterialShell/settings.json".source = ../../etc/DankMaterialShell-tp/settings.json;
      ".config/fastfetch".source = ../../etc/fastfetch;
      # ".config/fish".source = ../../etc/fish;
      ".config/ghostty".source = ../../etc/ghostty;
      ".config/git/config".source = ../../etc/git/config;
      ".config/jj/config.toml".source = ../../etc/jj/config.toml;
      ".config/MangoHud".source = ../../etc/MangoHud;
      ".config/mpv".source = ../../etc/mpv;
      ".config/niri".source = ../../etc/niri-tp;
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
