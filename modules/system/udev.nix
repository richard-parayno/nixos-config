{ self, inputs, ... }:
{
  flake.nixosModules.udev =
    { ... }:
    {
      # Allow user access to hidraw devices for WebHID
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev"
      '';
    };
}
