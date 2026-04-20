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

      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      security.pam.services.gdm = {
        fprintAuth = true;
        enableGnomeKeyring = true;
      };

      security.pam.services.login = {
        enableGnomeKeyring = true;
      };

      programs.mango.enable = true;
    };
}
