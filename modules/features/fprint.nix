{ self, inputs, ... }:
{
  flake.nixosModules.fprint =
    { pkgs, ... }:
    {
      services.fprintd.enable = true;

      security.pam.services = {
        login = {
          fprintAuth = false;
          # kwallet.enable = true;
        };
        sudo.fprintAuth = true;
      };
    };
}
