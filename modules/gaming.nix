{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.overworld.gaming.enable {
    # Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin.steamcompattool];
    };
    hardware.steam-hardware.enable = true;

    environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      heroic # Epic games launcher
      mangohud # Performance monitoring
      mindustry-wayland # Mindustry
      osu-lazer-bin # Osu! my beloved
      devilutionx # Stay a while and listen
      jetbrains.jdk # OpenJDK does not ship JavaFX for Minecraft
      mcrcon # RCON server for Minecraft servers
      deadlock-mod-manager
    ];
  };
}
