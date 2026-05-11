{ ... }:
{
  flake.nixosModules.plasma =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;

      services.displayManager.plasma-login-manager = {
        enable = true;
      };

      security.pam.services.plasma-login-manager = {
        fprintAuth = true;
        # enableGnomeKeyring = true;
        kwallet.enable = true;
        pamMount = true;
      };
    };
}
