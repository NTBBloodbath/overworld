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
      mangohud # Performance monitoring
      # mindustry-wayland # Mindustry BROKEN
    ]
    ++ (lib.optionals config.overworld.gaming.heroic.enable [ heroic ])
    ++ (lib.optionals config.overworld.gaming.diablo.enable [ devilutionx ])
    ++ (lib.optionals config.overworld.gaming.minecraft.enable [ mcrcon jetbrains.jdk ]);
  };
}
