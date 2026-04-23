{
  self,
  inputs,
  ...
}:
let
  userName = "richard";
  hostName = "netrunner";
in
{
  flake.nixosModules.netrunnerConfiguration =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.netrunner-hardware
        self.nixosModules.user
        self.nixosModules.common-system-config
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${userName}.imports = [ self.homeModules.${userName} ];
      };

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        maxGenerations = 5;
      };

      networking.hostName = hostName;
      networking.networkmanager.enable = true;

      system.stateVersion = "25.05";
    };
}
