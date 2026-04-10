{ self, inputs, ... }:
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel-gen6
      inputs.agenix.nixosModules.default
      self.nixosModules.thinkpadConfiguration
    ];
  };
}
