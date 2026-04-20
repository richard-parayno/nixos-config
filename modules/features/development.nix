{ self, inputs, ... }:
{
  flake.nixosModules.development =
    { pkgs, config, ... }:
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
        # TTYs
        ghostty
        alacritty
        kitty
        wezterm
        foot
        # Dev tooling
        zoxide
        zellij
        lazygit
        mise
        # Editors
        neovim
        helix
        zed-editor-fhs
        # AI
        opencode
        pi-coding-agent
        codex
        # dev utils
        nodejs_25
        bun
        hugo
      ];

      # set nvim as default editor
      programs.neovim.defaultEditor = true;

      # enable tmux
      programs.tmux = {
        enable = true;
        clock24 = true;
        extraConfig = ''
          set -g extended-keys on
          set -g extended-keys-format csi-u
          set -g mouse on
          set -sg escape-time 0
        '';
      };

      # enable dynamically linked non-nix executables
      programs.nix-ld.enable = true;

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

      # enable podman and explicitly disable docker
      virtualisation = {
        docker.enable = false;
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
        };
      };

      # enable passwordless sudo for podman
      security.sudo.extraRules = [
        {
          users = [ userName ];
          commands = [
            {
              command = "/run/current-system/sw/bin/podman";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
