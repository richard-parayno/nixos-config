{
  self,
  inputs,
  withSystem,
  ...
}:
let
  userName = "richard";
  gitName = "Richard Parayno";
  gitEmail = "broodheart@gmail.com";
in
{
  flake.homeConfigurations.${userName} = withSystem "x86_64-linux" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.agenix.homeManagerModules.default
        self.homeModules.${userName}
      ];

    }
  );

  flake.homeModules.${userName} =
    { pkgs, config, ... }:
    {
      imports = [
        self.homeModules.cursor
        self.homeModules.figma-agent
      ];

      home.username = userName;
      home.homeDirectory = "/home/${userName}";
      home.stateVersion = "25.05";

      xdg.enable = true;

      programs.git = {
        enable = true;
        settings.user = {
          name = gitName;
          email = gitEmail;
        };
        signing = {
          format = "ssh";
          signByDefault = true;
        };
      };

      # GH cli
      programs.gh = {
        enable = true;
        gitCredentialHelper = {
          enable = true;
          hosts = [ "github.com" ];
        };
      };

      # use fish
      programs.fish = {
        enable = true;
      };

      programs.ghostty = {
        enable = true;
        systemd.enable = true;
      };

      home.sessionVariables = {
        SHELL = "${pkgs.fish}/bin/fish";
        XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
      };

      programs.starship.enableFishIntegration = true;
      programs.zoxide.enableFishIntegration = true;
      programs.lazygit.enableFishIntegration = true;

      programs.firefox.enable = true;

      programs.zoxide.enable = true;
    };
}
