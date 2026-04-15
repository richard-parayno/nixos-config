{ self, inputs, ... }:
{
  flake.nixosModules.common-system-config =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.app-image # app image support
        self.nixosModules.tailscale # vpn
        self.nixosModules.firewall # firewall config
        self.nixosModules.ssh # ssh configuration
        self.nixosModules.audio # audio configuration
        self.nixosModules.development # dev-related stuff
        self.nixosModules.udev # udev rules
        self.nixosModules.obs # obs with plugins
        self.nixosModules.browser # browsers
        self.nixosModules.fonts # font packages and fontconfig
        self.nixosModules.cursor # cursor install
        self.nixosModules.usenet # usenet
        self.nixosModules.common-utils # common system packages
        self.nixosModules.common-apps # common applications
        self.nixosModules.flatpak # flatpak support
      ];

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.substituters = [
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://attic.xuyh0120.win/lantian"
        "https://noctalia.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
      nix.settings.trusted-users = [
        "root"
        "richard"
      ];

      # Timezone
      time.timeZone = "Asia/Manila";
      hardware.enableRedistributableFirmware = true;

      # Locale
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Printing
      services.printing.enable = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # for iphones
      services.usbmuxd.enable = true;
      services.usbmuxd.package = pkgs.usbmuxd2;

      # Bluetooth (change as needed)
      hardware.bluetooth.enable = true;

      # Keyboard layout
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Network file sharing support
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      # Enable Avahi for mDNS network discovery (for Nemo network panel)
      services.avahi = {
        enable = true;
        nssmdns4 = true; # Enable mDNS in NSS
        openFirewall = true;
      };

      # file sharing via local network
      programs.localsend.enable = true;

      # enable zram swap so daily use doesnt get scuffed.
      zramSwap.enable = true;
      # set zram swappiness to 100 (linux default is 60)
      boot.kernel.sysctl = {
        "vm.swappiness" = 100;
      };
    };
}
