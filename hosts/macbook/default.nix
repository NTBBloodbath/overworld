{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    # Enable conditional configurations
    overworld.macbook.enable = true;

    # Enable OpenGL and hardware accelerated graphics drivers
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };

    # System hostname
    networking.hostName = "taiga";

    # $HOME management
    hjem.users.amartin.files = {
      # Configuration files
      ".config/beets".source = ../../etc/beets;
      ".config/DankMaterialShell".source = ../../etc/DankMaterialShell-mbp;
      ".config/fastfetch".source = ../../etc/fastfetch;
      # ".config/fish".source = ../../etc/fish;
      ".config/ghostty".source = ../../etc/ghostty;
      ".config/git".source = ../../etc/git;
      ".config/jj".source = ../../etc/jj;
      ".config/MangoHud".source = ../../etc/MangoHud;
      ".config/mpv".source = ../../etc/mpv;
      ".config/niri".source = ../../etc/niri-mbp;
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
