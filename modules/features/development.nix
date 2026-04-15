{ self, inputs, ... }:
{
  flake.nixosModules.development =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.lsp
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

      # enable tmux
      programs.tmux = {
        enable = true;
        clock24 = true;
        extraConfig = ''
          set -g extended-keys on
          set -g extended-keys-format csi-u
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

      # Enable Docker Rootless Mode
      virtualisation.docker = {
        enable = false; # disable system docker daemon

        rootless = {
          enable = true; # but enable rootless docker
          setSocketVariable = true;
        };
      };
    };
}
