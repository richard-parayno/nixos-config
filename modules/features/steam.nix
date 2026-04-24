{ ... }:
{
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gamemode
        protonup-qt
        protontricks
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;

      programs.steam.package = pkgs.steam.override {
        extraPkgs =
          pkgs': with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
          ];
      };
    };
}
