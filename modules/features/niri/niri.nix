{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.niri =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      niri_config = "${config.home.homeDirectory}/nixos-config/modules/features/niri/niri-config.kdl";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # use symlink config for now while i haven't finalized the niri conf
      xdg.configFile."niri/config.kdl" = {
        source = create_symlink niri_config;
        force = true; # niri-config.kdl will always be the source of truth
      };
    };
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        alacritty
        fuzzel
        swaylock
        mako
        swayidle
        xwayland-satellite
        kdePackages.qt6ct
        kdePackages.ark # preferred graphical unrar
        kdePackages.okular # preferred pdf reader
      ];

      programs.niri = {
        enable = true;
        # package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
      };
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        # "config.kdl" = {
        #   content = builtins.readFile ./niri-config.kdl;
        # };
        # settings = {

        #   input = {
        #     keyboard = {
        #       xkb.layout = "us";
        #     };

        #     touchpad = {
        #       scroll-factor = 0.4;
        #     };

        #     trackpoint = {
        #       accel-speed = 0.1;
        #     };

        #     # max-scroll-amount = "30%";
        #   };

        #   layout.gaps = 5;

        #   binds = {

        #     "Mod+Left" = {
        #       focus-column-left = _: { };
        #     };
        #     "Mod+H" = {
        #       focus-column-left = _: { };
        #     };
        #     "Mod+Right" = {
        #       focus-column-right = _: { };
        #     };
        #     "Mod+L" = {
        #       focus-column-left = _: { };
        #     };
        #     "Mod+Up" = {
        #       focus-window-up = _: { };
        #     };
        #     "Mod+K" = {
        #       focus-window-up = _: { };
        #     };
        #     "Mod+Down" = {
        #       focus-window-down = _: { };
        #     };
        #     "Mod+J" = {
        #       focus-window-down = _: { };
        #     };
        #     "Mod+Page_Up" = {
        #       focus-workspace-up = _: { };
        #     };
        #     "Mod+Page_Down" = {
        #       focus-workspace-down = _: { };
        #     };
        #     "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
        #     "Mod+D".spawn-sh = "dms ipc call spotlight toggle";
        #   };
        # };
      };

    };
}
