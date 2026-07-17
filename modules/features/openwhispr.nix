{ self, inputs, ... }:
{
  flake.nixosModules.openwhispr =
    { pkgs, ... }:
    {
      # import the openwhispr overlay
      imports = [
        inputs.openwhispr.nixosModules.default
      ];

      programs.openwhispr = {
        enable = true;
        users = [ "richard" ];
      };
    };
}
