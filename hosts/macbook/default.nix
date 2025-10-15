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
  };
}
