{ ... }:
{
  flake.homeModules.figma-agent =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        figma-agent
      ];

      xdg.configFile."figma-agent/config.json".text = builtins.toJSON {
        bind = "127.0.0.1:44950";
        use_system_fonts = true;
        font_directories = [ "/run/current-system/sw/share/X11/fonts" ];
        enable_font_rescan = true;
        enable_font_preview = true;
      };

      systemd.user.services.figma-agent = {
        Unit = {
          Description = "Figma Agent for Linux - Local Font Access";
          Documentation = "https://github.com/neetly/figma-agent-linux";
          After = [ "network.target" ];
        };
        Service = {
          ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
          Restart = "on-failure";
          RestartSec = "5s";
          # Security hardening
          PrivateTmp = true;
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = "read-only";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      systemd.user.sockets.figma-agent = {
        Unit = {
          Description = "Figma Agent Socket";
          Documentation = "https://github.com/neetly/figma-agent-linux";
        };
        Socket = {
          ListenStream = "127.0.0.1:44950";
          Accept = false;
        };
        Install = {
          WantedBy = [ "sockets.target" ];
        };
      };
    };
}
