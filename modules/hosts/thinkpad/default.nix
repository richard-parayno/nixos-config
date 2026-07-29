{ self, inputs, ... }:
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel-gen6
      inputs.agenix.nixosModules.default
      inputs.nix-flatpak.nixosModules.nix-flatpak
      inputs.hermes-agent.nixosModules.default
      self.nixosModules.thinkpadConfiguration
      inputs.nix-index-database.nixosModules.default
    ];
  };
}
