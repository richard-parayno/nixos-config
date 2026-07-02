{ ... }:
{
  flake.nixosModules.vr =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wayvr # access wayland/x11 desktop environment in vr
        android-tools # so we can get adb for wired pcvr using the quest 3
      ];
      programs.alvr = {
        enable = true;
        openFirewall = true;
      };
      services.wivrn = {
        enable = true;
        openFirewall = true;

        # Run WiVRn as a systemd service on startup
        autoStart = true;
        highPriority = true; # enable high priority capability for asynchronous reprojection

        steam = {
          enable = true; # enable steam support
          importOXRRuntimes = true; # set PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES system-wide
        };

        # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
        package = (pkgs.wivrn.override { cudaSupport = true; });

        # You should use the default configuration (which is no configuration), as that works the best out of the box.
        # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.

        # add this env variable for openxr games on steam
        # PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/wivrn/comp_ipc %command%
      };

    };
}
