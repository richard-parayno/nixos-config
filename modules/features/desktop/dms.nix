{ inputs, self, ... }:
{
  flake.nixosModules.dms =
    { pkgs, ... }:
    {
      programs.dms-shell = {
        enable = true;
        quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell; # build quickshell from source
        systemd = {
          enable = true;
          restartIfChanged = true;
        };
      };
    };
}
