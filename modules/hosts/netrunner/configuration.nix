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
      config,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.netrunner-hardware
        self.nixosModules.user
        self.nixosModules.common-system-config
        self.nixosModules.mango # mango wm
        self.nixosModules.noctalia # noctalia-shell
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

      # use agenix
      age.secrets.github-pat.file = self + /secrets/github-pat.age;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.extraOptions = ''
        !include ${config.age.secrets.github-pat.path}
      '';

      networking.hostName = hostName;
      networking.networkmanager.enable = true;

      services.scx.enable = true; # enable sched-ext
      services.scx.scheduler = "scx_lavd";

      hardware = {
        nvidia = {
          open = false;
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          nvidiaSettings = true;
        };
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
            libvdpau-va-gl
          ];
        };
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      programs.steam.package = pkgs.steam.override {
        extraPkgs =
          pkgs': with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
          ];
      };

      nixpkgs.config.nvidia.acceptLicense = true;

      # env vars for stuff like vaapi/hardware acceleration on nvidia
      environment.variables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # gdm specific
        GSK_RENDERER = "ngl";
        XCURSOR_SIZE = "16";
        __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
      };

      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # enable swapfile for hibernation
      swapDevices = [
        {
          device = "/swap";
          size = 30 * 1024;
          options = [ "discard" ];
        }
      ];

      # use systemd to auto resolve swapfile location
      boot.initrd.systemd.enable = true;

      fileSystems."/mnt/SpeedyZwei" = {
        device = "/dev/disk/by-uuid/22865d28-bd6a-4528-96b9-a9a39864492e";
        fsType = "btrfs";
        options = [
          "users" # Allows any user to mount and unmount
          "nofail" # Prevent system from failing if this drive doesn't mount
          "exec" # Allow execution of binaries (required for Steam libraries)
        ];
      };

      system.stateVersion = "25.05";
    };
}
