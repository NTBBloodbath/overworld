{ config, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable wireless network support via wpa_supplicant
  # networking.wireless.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether
  # networking.firewall.enable = false;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = config.overworld.bluetoothOnBoot.enable;
  };

  # If your DE does not provide a GUI for pairing bluetooth devices
  # you can additionally enable the blueman service, which provides
  # blueman-applet and blueman-manager
  # services.blueman.enable = true;

  # Enable SSH
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      # Allow host names to be used in authorized_keys
      UseDns = true;
      # Forbid root login through SSH
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };
}
