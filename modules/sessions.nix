{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.xserver = {
    # Enable the X11 windowing system
    enable = true;
    videoDrivers = [] ++ (lib.optionals config.overworld.amd.enable ["amdgpu"]);

    # Configure keymap in X11
    xkb =
      if config.overworld.macbook.enable
      then {
        layout = "us";
        variant = "mac";
      }
      else {
        layout = "latam";
        variant = "";
      };

    # Disable XTerm
    desktopManager.xterm.enable = false;
  };

  # Niri, scrollable-tiling Wayland compositor
  programs.niri = {
    enable = true;
    package = if config.overworld.macbook.enable then pkgs.niri else inputs.niri-git.packages.x86_64-linux.default;
  };

  environment.systemPackages = with pkgs;
    [
      # --- Yabbadabbadooo
      gvfs
      baobab
      nautilus
      seahorse
      adwaita-fonts
      gnome-disk-utility
      # --- Niri
      xwayland-satellite # Xwayland
      inputs.quickshell.packages.x86_64-linux.default # QuickShell go brr (DankMaterialShell)
      inputs.dank-material-shell.packages.x86_64-linux.default # DankMaterialShell
      # inputs.dms-cli.packages.x86_64-linux.default # CLI for DankMaterialShell
      inputs.dgop.packages.x86_64-linux.default # System monitor for DankMaterialShell
      mpvpaper # Animated wallpapers from MP4
      playerctl # Control audio
      swaybg # Wallpaper
      gammastep # Eye protection, required by DankMaterialShell
      cliphist # Clipboard manager, required by DankMaterialShell
      matugen # Material You color generator, required by DankMaterialShell
    ]
    ++ (lib.optionals config.overworld.macbook.enable [pkgs.brightnessctl]);

  # Automatically login
  services.displayManager.autoLogin = {
    user = "amartin";
    enable = true;
  };
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "niri-session";
        user = "amartin";
      };
      default_session = initial_session;
    };
  };

  # Make Electron applications use Wayland
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_LAUNCH_FLAGS = "--enable-wayland-ime --wayland-text-input-version=3 --enable-features=WaylandLinuxDrmSyncobj";
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    SDL_IM_MODULE = "ibus";
  };
}
