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
        settings = ''
          source=~/.config/mango/mango.conf
        '';
        # extraConfig = lib.readFile ./mango.conf;
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
          xdg-desktop-portal
        ];
        config = {
          mango = {
            "org.freedesktop.impl.portal.ScreenCast" = "wlr";
            "org.freedesktop.impl.portal.Screenshot" = "wlr";
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
          };
        };
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

      programs.mango.enable = true;

      environment.sessionVariables = {
        # XDG_CURRENT_DESKTOP = "mango";
        # QT_QPA_PLATFORM = "wayland";
        # QT_QPA_PLATFORMTHEME = "gtk3";
        # QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      };
    };
}
