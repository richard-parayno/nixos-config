{ self, inputs, ... }:
{
  # Self-hosted Amp orb provider backed by the host's (rootful) docker daemon.
  # https://ampcode.com/docs/orbs/self-hosted
  #
  # One provider token per machine: Amp says to run exactly one
  # `amp orb provider` per token, so each host gets its own provider
  # (created under Settings -> Orbs) and its own agenix secret.
  #
  # The secret is an env file:  AMP_ORB_PROVIDER_TOKEN=aop_live_...
  flake.nixosModules.amp-orb-provider =
    { pkgs, config, ... }:
    let
      hostName = config.networking.hostName;

      dispatch = pkgs.writeShellApplication {
        name = "amp-orb-dispatch";
        runtimeInputs = [ pkgs.docker-client ];
        text = ''
          case "$ORB_OPERATION" in
            spawn)
              image="$ORB_IMAGE"
              docker image inspect "''${ORB_SNAPSHOT_ID-}" >/dev/null 2>&1 && image="$ORB_SNAPSHOT_ID"
              # caps keep orbs from starving the desktop (12 threads / 16 GB)
              docker start "$ORB_ID" 2>/dev/null ||
                docker run --init --platform linux/amd64 -d --name "$ORB_ID" \
                  --shm-size=1g --cpus 4 --memory 6g \
                  "$image" sleep infinity
              docker exec -d --env ORB_TOKEN --env AMP_URL "$ORB_ID" amp orb bootstrap
              ;;
            pause)
              docker stop "$ORB_ID" 2>/dev/null || true
              [ -z "''${ORB_SNAPSHOT_ID-}" ] || docker commit "$ORB_ID" "$ORB_SNAPSHOT_ID"
              ;;
            delete)
              docker rm -f "$ORB_ID" 2>/dev/null || true
              ;;
            *)
              echo "unknown ORB_OPERATION: $ORB_OPERATION" >&2
              exit 1
              ;;
          esac
        '';
      };
    in
    {
      age.secrets.amp-orb-provider = {
        file = self + /secrets/amp-orb-provider-${hostName}.age;
        owner = "amp-orb";
      };

      # rootful daemon (development.nix also enables rootless for the user)
      virtualisation.docker.enable = true;

      users.groups.amp-orb = { };
      users.users.amp-orb = {
        isSystemUser = true;
        group = "amp-orb";
        extraGroups = [ "docker" ];
        home = "/var/lib/amp-orb";
      };

      systemd.services.amp-orb-provider = {
        description = "Amp self-hosted orb provider (docker)";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
          "docker.service"
        ];
        wants = [ "network-online.target" ];
        requires = [ "docker.service" ];
        environment.HOME = "/var/lib/amp-orb";
        serviceConfig = {
          User = "amp-orb";
          Group = "amp-orb";
          StateDirectory = "amp-orb";
          EnvironmentFile = config.age.secrets.amp-orb-provider.path;
          ExecStart = "${pkgs.amp-cli}/bin/amp orb provider ${dispatch}/bin/amp-orb-dispatch";
          Restart = "always";
          RestartSec = 10;
        };
      };
    };
}
