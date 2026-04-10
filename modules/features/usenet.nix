{ self, inputs, ... }:
{
  flake.nixosModules.usenet =
    { pkgs, ... }:
    {
      services.sabnzbd = {
        enable = true;
        openFirewall = true;
      };

      # services.nzbhydra2 = {
      #   enable = true;
      #   openFirewall = true;
      # };
    };
}
