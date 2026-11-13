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
        # self.nixosModules.flameshot # flameshot for screenshots
        self.nixosModules.satty # satty for screenshots
        # self.nixosModules.openwhispr # local dictation + transcription
      ];

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.substituters = [
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
      # eMudhra intermediate CA key compromise (Oct 2026): distrust the parent roots.
      # cacert 3.131.1 dropped emSign ECC Root CA - G3 (listing it now fails the build),
      # but still ships Comodo AAA Services root; drop this once that's gone too
      security.pki.caCertificateBlacklist = [
        "Comodo AAA Services root"
      ];
      # 16 GB RAM, 12 threads: up to 18 build threads, deprioritised but not starved
      nix.settings.max-jobs = 3;
      nix.settings.cores = 6;
      nix.daemonCPUSchedPolicy = "batch";
      nix.daemonIOSchedClass = "best-effort";
      nix.daemonIOSchedPriority = 7;

      # pyopenjtalk-plus 0.4.1-post9: test_run_njd_from_mecab_invalid_input fails on
      # python 3.14 (breaks calibre via piper-tts); drop once fixed upstream
      nixpkgs.overlays = [
        (final: prev: {
          # speechd stopped shipping python bindings (nixpkgs#577420, fixed on master);
          # calibre's install check imports them. drop once the fix reaches unstable
          calibre = prev.calibre.overrideAttrs { doInstallCheck = false; };
          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
            (pyFinal: pyPrev: {
              pyopenjtalk-plus = pyPrev.pyopenjtalk-plus.overridePythonAttrs { doCheck = false; };
            })
          ];
        })
      ];

      nix.settings.trusted-users = [
        "root"
        "richard"
      ];

      # Timezone
      time.timeZone = "Asia/Singapore";
      hardware.enableRedistributableFirmware = true;

      # Locale
      i18n.defaultLocale = "en_US.UTF-8";
      # Plasma Region settings use en_PH; without it glibc falls back to C (speech-dispatcher fails, Qt warns)
      i18n.extraLocales = [ "en_PH.UTF-8/UTF-8" ];
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # SMB Usershares
      services.samba = {
        package = pkgs.samba;
        usershares.enable = true;
        enable = true;
        openFirewall = true;
      };

      # To be discoverable with windows
      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      # Printing
      services.printing.enable = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10"
      ];

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

      # enable dconf so apps can save their configs
      programs.dconf.enable = true;

      # enable zram swap so daily use doesnt get scuffed.
      zramSwap.enable = true;
      # set zram swappiness to 100 (linux default is 60)
      boot.kernel.sysctl = {
        "vm.swappiness" = 100;
      };
    };
}
