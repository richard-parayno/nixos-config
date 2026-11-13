{ self, inputs, ... }:
{
  # Amp runner: lets ampcode.com / `amp --executor runner:<host>` start
  # threads on this machine, directly on the host (no container).
  # https://ampcode.com/docs/cli/runners
  #
  # Threads run as the OS user that started the runner and are NOT sandboxed
  # to the served dirs, so this runs as richard with his normal tooling.
  #
  # Auth is an access token (Settings -> access tokens, starts with sgamp_);
  # `amp login`'s stored session expires within an hour.
  # The secret is an env file:  AMP_API_KEY=sgamp_...
  flake.nixosModules.amp-runner =
    { pkgs, lib, config, ... }:
    let
      userName = "richard";
      home = "/home/${userName}";
      runnerId = config.networking.hostName;

      args = [
        "--no-tui"
        "--runner-id"
        runnerId
        "--no-serve-cwd"
        "--dir"
        "${home}/nixos-config"
        # git checkouts up to two levels below these
        "--discover-dirs=${home}/Projects"
        "--discover-dirs=${home}/work-dev"
      ];
    in
    {
      age.secrets.amp-runner = {
        file = self + /secrets/amp-runner.age;
        owner = userName;
      };

      systemd.services.amp-runner = {
        description = "Amp runner (${runnerId})";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        environment = {
          HOME = home;
          # amp lives in the read-only store; nix handles updates
          AMP_SKIP_UPDATE_CHECK = "1";
          # give threads the same tools as an interactive shell
          PATH = lib.mkForce (
            lib.concatStringsSep ":" [
              "/run/wrappers/bin"
              "/etc/profiles/per-user/${userName}/bin"
              "${home}/.nix-profile/bin"
              "/run/current-system/sw/bin"
            ]
          );
        };
        serviceConfig = {
          User = userName;
          Group = "users";
          WorkingDirectory = home;
          EnvironmentFile = config.age.secrets.amp-runner.path;
          ExecStart = "${lib.getExe pkgs.amp-cli} ${lib.escapeShellArgs args}";
          Restart = "always";
          RestartSec = 10;
        };
      };
    };
}
