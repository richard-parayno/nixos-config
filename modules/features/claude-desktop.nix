{ inputs, ... }:
{
  flake.nixosModules.claude-desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
