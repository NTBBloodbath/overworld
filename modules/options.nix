{lib, ...}: {
  options.overworld = {
    # Laptop specific configurations
    macbook.enable = lib.mkEnableOption "Enable Macbook related programs and services";

    # Desktop specific configurations (Ryzen, AMDGPU)
    amd.enable = lib.mkEnableOption "Enable AMD hardware related configurations";

    # Misc stuff
    gaming.enable = lib.mkEnableOption "Whether to install gaming packages";

    # Services
    mpd.enable = lib.mkEnableOption "Whether to enable MPD service";
    lact.enable = lib.mkEnableOption "Whether to enable LACT service";
    cloudflare.enable = lib.mkEnableOption "Whether to enable Cloudflare WARP service";
    bluetoothOnBoot.enable = lib.mkEnableOption "Whether to power Bluetooth on boot";
  };
}
