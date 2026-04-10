{ self, inputs, ... }:
{
  flake.nixosModules.tailscale =
    { pkgs, ... }:
    {
      services.tailscale.enable = true;

      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
    };
}
