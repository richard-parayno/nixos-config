{ self, inputs, ... }:
{
  flake.nixosModules.common-utils =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cifs-utils # smb/cifs
        sbctl # secure boot
        gvfs # file manager integration for network shares
        samba
        wsdd # ws-discovery daemon for smb share discovery
        cachix # nix binary cache
        pika-backup # backup client
        usbutils # lsusb etc
        mpv # media player
        nwg-look # gtk settings
        fuse # filesystem
        nemo-with-extensions # file manager
        kdePackages.ark # kde file unzipper
        p7zip
        unrar
        libimobiledevice # iphone
        ifuse # iphone
        font-manager # font management for gtk
        brightnessctl # screen brightness control
        wl-clipboard # wayland clipboard
        valent # kde connect but gnome
        pulseaudio # volume control for pulse audio
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default # age secrets management from flake
        # themes
        morewaita-icon-theme
        adwaita-icon-theme
        arashi
        iconpack-obsidian
        theme-obsidian2
        gnome-themes-extra
        # end themes
      ];

      # enable nh (nix helper)
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
      };

    };
}
