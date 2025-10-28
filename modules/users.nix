{
  pkgs,
  inputs,
  ...
}: {
  programs.openvpn3.enable = true;

  users.users = {
    amartin = {
      isNormalUser = true;
      description = "Alejandro Martin";
      extraGroups = ["networkmanager" "wheel" "adbusers" "input"];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCiWCwImy+yWSp5kaCF506UORbzZjMQ/QOuYZP+iuYE7G0TAnUURF7T8Jai/8opztMCSPkUlTvBS91UhbMkKhIUeytxxN+cCVIGmpuX9WmbAxcbbMksPR8CRcvcOtc9zi21xy65db6BTa7uTp0GTeti4YsN6oRxgKPSUeZHV9ZjleqPaE3XwNC4tKlB2T9L77fOruDLpk+I0ccdkgWbOs891bjNe3zoxPyXIo60RyN79Kor0NQKxmvkKOOIXulYm88nw6lM5sufwVhd1EfEmVPuyOuNoNmGRBYOWrDt1kPr9Tjex6O+8NzjhVYhcqb7dzpLiglsXG35Y9E1IjzV4woZaImVbKcZi3Cm1Q1n+Syav5gfKVyG1lAAF6OTT89XC+3J2Vlvs6OVfRVhXI/j9I3Kv5mRCrKHY9/X5f6SLV9IqVa64tRxrNFNk4emj+FCbikcHwoG48nIa174Owgw6jEOUjUQMMYKDu7A1vZEZ1owd/0AxbFmAofLS0tSm/IcJm4ps+YGu4cPf5OpTCCMhh8mri523CfwA8hkvFaup2UAAHaacrkPEilGWeaUiSHzTg3pB7uNLne/B/tDUY0y+WpSuXhwu9RgW0GterxwovwhnECbU69Hix69wJeIWRjXpUiZLvn9sgTxUbjsq3nUru0ZJ1I9buEQJM1mBczY6PWpxQ== bloodbathalchemist@protonmail.com"
      ];
      packages = with pkgs; [
        # Terminal emulators
        kitty # required to get the kitten utility to display images on Ghostty
        ghostty
        # Development tools
        yaak
        cachix
        devenv
        vscode.fhs
        penpot-desktop
        alejandra # Nix formatter
        inputs.norgolith.packages.x86_64-linux.default
        chromium # Separate browser for work
        # Social
        slack
        vesktop
        signal-desktop
        element-desktop
        # Multimedia
        svp
        vlc
        ffmpeg
        inkscape
        obs-studio
        spotify # Patched with SpotX through an overlay
        cameractrls
        pavucontrol
        nicotine-plus # Soulseek client
        # Misc
        newsflash # RSS Reader
        bottles # Wine made easy
        protonvpn-gui # Goofy ahh VPN service need
        qbittorrent
      ];
    };
  };
}
