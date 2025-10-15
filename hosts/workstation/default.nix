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
  };
}
