{ inputs, ... }:
{
  flake.nixosModules.openmw =
    { pkgs, ... }:
    let
      openmwPackages = inputs.openmw-nix.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = with openmwPackages; [
        delta-plugin
        openmw-dev
        openmw-validator
        plox
      ];
    };
}
