{
  self,
  inputs,
  ...
}:
let
  userName = "richard";
  hostName = "thinkpad";
in
{

  flake.nixosModules.thinkpadConfiguration =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.thinkpad-hardware # hardware configuration
        self.nixosModules.user # user account
        # self.nixosModules.niri # window manager
        self.nixosModules.mango # try mango wm
        self.nixosModules.plasma # kde plasma
        # self.nixosModules.gnome # gnome
        # self.nixosModules.ly # login manager
        # self.nixosModules.dms # dank-material-shell
        self.nixosModules.noctalia # noctalia-shell
        self.nixosModules.fprint # fingerprint reader
        self.nixosModules.common-system-config # common system-level settings
        self.nixosModules.tlp # power config
        self.nixosModules.gaming # gaming packages

      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${userName}.imports = [ self.homeModules.${userName} ];
      };

      # use agenix
      age.secrets.github-pat.file = self + /secrets/github-pat.age;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.extraOptions = ''
        !include ${config.age.secrets.github-pat.path}
      '';

      # Bootloader
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        maxGenerations = 5;
      };

      # Kernel
      boot.kernelPackages = pkgs.linuxPackages_latest; # default latest from nixpkgs
      # boot params
      # this is a temporary workaround that brings CPU usage of irq-9/acpi from 90% to 0% when connected on AC.
      # This issue started popping up when I replaced the original Lenovo battery to an aftermarket KingSener battery.
      boot.kernelParams = [ "acpi_mask_gpe=0x6D" ];

      # Networking
      networking.hostName = hostName;
      networking.networkmanager.enable = true;

      fileSystems."/mnt/nas-richard" = {
        device = "//192.168.1.105/richard";
        fsType = "cifs";
        options =
          let
            # this line prevents hanging on network split
            automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          in
          [
            "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${toString config.users.users.richard.uid},gid=${toString config.users.groups.users.gid}"
          ];
      };

      programs.captive-browser.enable = true;
      programs.captive-browser.interface = "wlp0s20f3";

      # Services
      services.fwupd.enable = true;
      # services.thinkfan.enable = true;
      services.upower.enable = true; # to get battery icons on laptops
      # services.thermald.enable = true;
      # System-wide setting, but make sure your DE/WM doesn't override this (like Niri)
      services.libinput.touchpad.disableWhileTyping = true;
      services.libinput.touchpad.tapping = false;

      # X Server
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "modesetting" ];

      # Graphics
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ];
      };

      # common environment variables (usually wayland stuff)
      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };

      environment.variables.XCURSOR_SIZE = "40";

      # Keep the Goodix fingerprint reader powered across re-enumeration.
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="27c6", ATTRS{idProduct}=="659a", ATTR{power/persist}="1", RUN="/${pkgs.coreutils}/bin/chmod 444 %S%p/../power/persist"
      '';

      # Hibernation settings
      boot.resumeDevice = "/dev/disk/by-uuid/86c92295-667b-4029-9f80-7c67d2832129";

      system.stateVersion = "25.11";
    };
}
