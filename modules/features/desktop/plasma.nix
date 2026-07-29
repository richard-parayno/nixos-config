{ ... }:
{
  flake.nixosModules.plasma =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;

      services.displayManager.plasma-login-manager = {
        enable = true;
      };

      # security.pam.services.plasmalogin = {
      #   fprintAuth = true;
      #   # enableGnomeKeyring = true;
      #   kwallet.enable = true;
      #   pamMount = true;
      # };

      xdg.portal.configPackages = with pkgs; [
        kdePackages.plasma-workspace
      ];
    };
}
