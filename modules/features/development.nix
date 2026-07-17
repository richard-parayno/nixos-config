{ self, inputs, ... }:
{
  flake.nixosModules.development =
    {
      pkgs,
      config,
      ...
    }:
    let
      userName = "richard";
    in
    {
      imports = [
        self.nixosModules.lsp
        self.nixosModules.hermes-agent
      ];

      environment.systemPackages = with pkgs; [
        # core
        fastfetch
        unzip
        unrar
        wget
        git
        btop
        gnupg
        pinentry-all
        wl-clipboard
        ripgrep
        ydotool
        # TTYs
        ghostty
        alacritty
        kitty
        wezterm
        foot
        # Dev tooling
        herdr
        devenv
        zoxide
        zellij
        lazygit
        mise
        bubblewrap
        distrobox
        # Editors
        neovim
        helix
        code-cursor-fhs
        # inputs.zed-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
        zed-editor-fhs
        # AI
        # opencode
        # opencode-desktop
        agent-browser
        # dev utils
        nodejs_latest
        python315
        bun
        hugo
        # virtualization related
        dnsmasq

      ];

      # enable nix-index-database and wrap comma
      programs.nix-index-database.comma.enable = true;

      # set nvim as default editor
      programs.neovim.defaultEditor = true;

      # enable tmux
      programs.tmux = {
        enable = true;
        clock24 = true;
        plugins = [
          pkgs.tmuxPlugins.resurrect
          pkgs.tmuxPlugins.continuum
          pkgs.tmuxPlugins.yank
        ];
        extraConfig = ''
          set -g default-shell ${pkgs.fish}/bin/fish
          set -g @plugin 'tmux-plugins/tpm'
          set -g @plugin 'tmux-plugins/tmux-resurrect'
          set -g @plugin 'tmux-plugins/tmux-continuum'
          set -g @plugin 'tmux-plugins/tmux-yank'
          set -g extended-keys on
          set -g extended-keys-format csi-u
          set -g mouse on
          set -sg escape-time 0
          set -g status-right 'Continuum status: #{continuum_status}'
        '';
      };

      # Support binaries downloaded outside of Nix, like agent-browser's Chrome.
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          glib
          nspr
          nss
          atk
          at-spi2-atk
          at-spi2-core
          dbus
          cups
          expat
          alsa-lib
          cairo
          gtk3
          libgbm
          libx11
          libxcb
          libxcomposite
          libxcursor
          libxdamage
          libxext
          libxfixes
          libxi
          libxkbcommon
          libxrandr
          libxrender
          libxscrnsaver
          libxtst
          pango
          xorg.libXinerama
        ];
      };

      # shells
      programs.zsh.enable = true;
      programs.fish.enable = true;

      # prompt
      programs.starship.enable = true;

      # enable direnv but clean up the outputs when it activates
      programs.direnv.enable = true;
      programs.direnv.settings = {
        global = {
          log_filter = "^$";
        };
      };

      # enable docker
      virtualisation = {
        docker = {
          enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
        };
      };

      # enable qemu + virtmanager
      virtualisation.libvirtd.enable = true;
      virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      programs.virt-manager.enable = true;

      # enable passwordless sudo for docker
      security.sudo.extraRules = [
        {
          users = [ userName ];
          commands = [
            {
              command = "/run/current-system/sw/bin/docker";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
