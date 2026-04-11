{ self, ... }:
{
  flake.nixosModules.tlp =
    { pkgs, ... }:
    {
      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          # AC/Charger settings
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_BOOST_ON_AC = 1;

          # OS level Battery settings
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
          CPU_BOOST_ON_BAT = 0;

          # Firmware level battery profile
          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "performance";
          PLATFORM_PROFILE_ON_SAV = "power-saver";

          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 80;

          # Battery charge thresholds
          START_CHARGE_THRESH_BAT0 = 40;
          STOP_CHARGE_THRESH_BAT0 = 80;

          TLP_AUTO_SWITCH = 2;

        };
        pd.enable = true; # enable power-profiles-daemon interface
      };
    };
}
