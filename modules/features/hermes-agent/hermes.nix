{
  self,
  inputs,
  lib,
  ...
}:
{
  # wrap fastapi and uvicorn into the hermes-agent package
  # perSystem =
  #   { pkgs, ... }:
  #   {
  #     packages.hermes-agent-wrapped = inputs.wrapper-modules.lib.wrapPackage (
  #       { ... }:
  #       {
  #         inherit pkgs;

  #         package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;

  #         env.PYTHONPATH = pkgs.python311Packages.makePythonPath [
  #           pkgs.python311Packages.fastapi
  #           pkgs.python311Packages.uvicorn
  #         ];

  #       }
  #     );
  #   };

  flake.nixosModules.hermes-agent =
    { pkgs, config, ... }:
    let
      userName = "richard";
    in
    {
      # use agenix for api-keys
      age.secrets.api-keys.file = self + /secrets/api-keys.age;

      # enable hermes-agent
      services.hermes-agent = {
        # package = self.packages.${pkgs.stdenv.hostPlatform.system}.hermes-agent-wrapped;
        enable = true;
        addToSystemPackages = true;
        restart = "always";
        restartSec = 5;
        # configFile = self + /modules/features/hermes-agent/config.yaml; # don't manage config file via Nix

        # API keys
        environmentFiles = [ config.age.secrets.api-keys.path ];

        # Model Settings
        settings = {
          model = {
            base_url = "https://chatgpt.com/backend-api/codex";
            provider = "openai-codex";
            default = "gpt-5.4";
          };
          providers = {
            local = {
              api = "http://m1.tail11e634.ts.net:8888/v1";
              api_key = "\${LOCAL_LLM_API_KEY}";
              default_model = "Qwen3.5-9B-MLX-4bit";
              models = [
                "Qwen3.5-9B-MLX-4bit"
              ];
            };
          };
          toolsets = [ "all" ];
          max_turns = 100;
          terminal = {
            backend = "local";
            timeout = 180;
          };
          compression = {
            enabled = true;
            threshold = 0.85;
          };
          memory = {
            memory_enabled = true;
            user_profile_enabled = true;
          };
          agent = {
            max_turns = 60;
            verbose = false;
          };
        };

        # Container opts
        container = {
          enable = true; # use container mode for hermes-agent so it has access to a mutable environment
          backend = "podman";
          image = "nikolaik/python-nodejs:python3.11-nodejs20";
          hostUsers = [ userName ];
          extraVolumes = [
            "${config.users.users.${userName}.home}/ai-sandbox:/home/hermes/ai-sandbox:rw"
            "${config.users.users.${userName}.home}/workdev/navegante_web:/home/hermes/navegante_web:rw"
          ]; # add the local ai-sandbox directory as a volume in docker
        };

        workingDirectory = "/home/hermes/ai-sandbox";
      };
    };
}
