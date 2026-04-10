{ inputs, self, ... }:
{
  flake.nixosModules.ly =
    { pkgs, ... }:
    {
      services.displayManager.ly = {
        enable = true;
        settings = {
          bigclock = "en";
          animation = "colormix";
        };
      };

      security.pam.services.ly = {
        fprintAuth = false;
        kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
      };
    };
}
