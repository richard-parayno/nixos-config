{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        alacritty
        fuzzel
        swaylock
        mako
        swayidle
        xwayland-satellite
      ];

      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      };
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          input.keyboard = {
            xkb.layout = "us";
          };

          layout.gaps = 5;

          binds = {
            "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
          };
        };
      };

    };
}
