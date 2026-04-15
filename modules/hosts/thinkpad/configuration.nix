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
        self.nixosModules.niri # window manager
        # self.nixosModules.ly # login manager
        # self.nixosModules.dms # dank-material-shell
        self.nixosModules.noctalia # noctalia-shell
        self.nixosModules.fprint # fingerprint reader
        self.nixosModules.common-system-config # common system-level settings
        self.nixosModules.tlp # power config

      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${userName}.imports = [ self.homeModules.${userName} ];
      };

      # use agenix
      age.secrets.github-pat.file = ../../../secrets/github-pat.age;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.access-tokens = config.age.secrets.github-pat.path;

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

      # Services
      services.fwupd.enable = true;
      services.thinkfan.enable = true;
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

      # Hibernation settings
      boot.resumeDevice = "/dev/disk/by-uuid/86c92295-667b-4029-9f80-7c67d2832129";

      system.stateVersion = "25.11";
    };
}
