{ self, inputs, ... }:
{
  flake.nixosModules.firewall =
    { pkgs, config, ... }:
    {
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ config.services.tailscale.port ];
        allowedTCPPorts = [
          3000
          9297
          9296
          9295
        ];
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      };

    };
}
