{ self, inputs, ... }:
{
  flake.nixosModules.udev =
    { pkgs, ... }:
    {
      # Allow user access to hidraw devices for WebHID
      # Enable USB persistence for the Thinkpad's fingerprint reader (ID 27c6:659a Shenzhen Goodix Technology Co.,Ltd. Goodix USB2.0 MISC)
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev"

        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="27c6", ATTRS{idProduct}=="659a", ATTR{power/persist}="1", RUN="/${pkgs.coreutils}/bin/chmod 444 %S%p/../power/persist"
      '';
    };
}
