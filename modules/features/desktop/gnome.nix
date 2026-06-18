{ ... }:
{
  flake.nixosModules.gnome =
    { pkgs, lib, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      services.gnome.gnome-keyring.enable = true; # enable gnome keyring

      security.pam.services.gdm = {
        pamMount = true;
      };

      security.pam.services.gdm-fingerprint.text = lib.mkForce "";

      security.pam.services.login = {
        enableGnomeKeyring = true;
      };

      programs.seahorse.enable = true; # seahorse is for managing gnome keyring secrets

      xdg.portal.configPackages = with pkgs; [
        kdePackages.plasma-workspace
      ];

      environment.systemPackages = with pkgs; [
        refine # tweak gnome settings
        gnome-browser-connector
      ];
    };
}
