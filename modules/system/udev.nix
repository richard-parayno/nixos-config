{ self, inputs, ... }:
{
  flake.nixosModules.udev =
    { ... }:
    {
      # 1. Allow user access to hidraw devices for WebHID
      # 2. Udev rules to allow access to moza devices for boxflat
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev"

        SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
      '';
    };
}
