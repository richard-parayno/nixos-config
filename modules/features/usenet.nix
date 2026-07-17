{ self, inputs, ... }:
{
  flake.nixosModules.usenet =
    { pkgs, ... }:
    {
      services.sabnzbd = {
        enable = false;
        openFirewall = true;
      };

      # services.nzbhydra2 = {
      #   enable = true;
      #   openFirewall = true;
      # };
    };
}
