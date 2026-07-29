{ self, inputs, ... }:
{
  flake.nixosConfigurations.netrunner = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.agenix.nixosModules.default
      inputs.nix-flatpak.nixosModules.nix-flatpak
      inputs.hermes-agent.nixosModules.default
      self.nixosModules.netrunnerConfiguration
      inputs.nix-index-database.nixosModules.default
    ];
  };
}
