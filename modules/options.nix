{lib, ...}: {
  options.overworld = {
    # Laptop specific configurations
    tp.enable = lib.mkEnableOption "Enable Thinkpad T14 Gen 1 (Intel) related programs and services";

    # Desktop specific configurations (Ryzen, AMDGPU)
    amd.enable = lib.mkEnableOption "Enable AMD hardware related configurations";

    # Gaming launchers and services
    gaming.enable = lib.mkEnableOption "Whether to install core gaming packages (Steam, gamemode, mangohud)";
    gaming.heroic.enable = lib.mkEnableOption "Whether to install Heroic launcher";
    gaming.diablo.enable = lib.mkEnableOption "Whether to install DevilutionX";
    gaming.minecraft.enable = lib.mkEnableOption "Whether to install OpenJDK and mcrcon packages";

    # Services
    mpd.enable = lib.mkEnableOption "Whether to enable MPD service";
    lact.enable = lib.mkEnableOption "Whether to enable LACT service";
    cloudflare.enable = lib.mkEnableOption "Whether to enable Cloudflare WARP service";
    jellyfin.enable = lib.mkEnableOption "Whether to enable Jellyfin media server service";
    bluetoothOnBoot.enable = lib.mkEnableOption "Whether to power Bluetooth on boot";
  };
}
