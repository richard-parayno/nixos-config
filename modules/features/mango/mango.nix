{ self, inputs, ... }:
{
  flake.homeModules.mango =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      mango_config = "${config.home.homeDirectory}/nixos-config/modules/features/mango/mango.conf";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      xdg.configFile."mango/mango.conf" = {
        source = create_symlink mango_config;
        force = true; # mango.conf will always be the source of truth
      };

      xdg.configFile."mango/config.conf".force = true;

      wayland.windowManager.mango = {
        enable = true;
        autostart_sh = ''
          noctalia-shell
        '';
        extraConfig = ''
          source=~/.config/mango/mango.conf
        '';
      };

    };

  flake.nixosModules.mango =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        foot
        rofi
        swaybg
        wl-clipboard
        libxcb-wm
      ];

      programs.mango = {
        enable = true;
        package = inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      };

      xdg.portal = {
        enable = true;
        # extraPortals = with pkgs; [
        #   xdg-desktop-portal-gtk
        #   xdg-desktop-portal-wlr
        #   xdg-desktop-portal
        #   kdePackages.xdg-desktop-portal-kde
        # ];
        xdgOpenUsePortal = true;
        config = {
          mango = {
            "org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
          };
          kde = {
            "org.freedesktop.impl.portal.ScreenCast" = "kde";
            "org.freedesktop.impl.portal.Screenshot" = "kde";
            "org.freedesktop.impl.portal.FileChooser" = "kde";
          };
        };
      };

      environment.sessionVariables = {
        # XDG_CURRENT_DESKTOP = "mango";
        # QT_QPA_PLATFORM = "wayland";
        # QT_QPA_PLATFORMTHEME = "gtk3";
        # QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      };
    };
}
