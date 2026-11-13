{ ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gamemode
        protonup-qt
        protontricks
        lsfg-vk
        lsfg-vk-ui
        boxflat
        # aws-lc-sys >= 0.42 is forced onto the system AWS-LC by nixpkgs
        # (AWS_LC_SYS_USE_SYSTEM=1), but the package doesn't provide it yet.
        (deadlock-mod-manager.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ aws-lc ];
        }))
        faugus-launcher
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;

      programs.steam.package = pkgs.steam.override {
        extraProfile = ''
          # Allows Monado/WiVRn to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          # Fixes timezones on VRChat
          unset TZ
        '';
        extraPkgs =
          pkgs': with pkgs'; [
            libxcursor
            libxi
            libxinerama
            libxscrnsaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
            xwayland-satellite
          ];
      };
    };
}
