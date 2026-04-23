{ pkgs, ... }:
{
  flake.nixosModules.satty =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        grim
        slurp
        satty
      ];
    };
}
