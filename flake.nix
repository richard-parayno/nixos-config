{
  inputs.self.submodules = true;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    gearlever-nixpkgs.url = "github:NixOS/nixpkgs/148bab9c1c3c53136ecb44a6ea356a0ed5b39b06";
    # nodejs 26.12.1 for Node2Shell (CVE-2026-111497); drop once nixos-unstable has it
    nodejs-nixpkgs.url = "github:NixOS/nixpkgs/eb5a4245a565f1fdee46042a53b64bee33fc5898";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openmw-nix = {
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # codex-desktop-linux = {
    #   url = "github:ilysenko/codex-desktop-linux";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ai agent tools
    # openwhispr.url = "github:openwhispr/openwhispr";
    # herdr comes from nixpkgs (see development.nix); flake input unused
    # herdr.url = "github:ogulcancelik/herdr";
    # hermes-agent = {
    #   url = "github:NousResearch/hermes-agent/6fb69229caba4bd5699228e520de4956b3458187";
    #   # url = "github:NousResearch/hermes-agent";
    # };
    # unused: nothing references inputs.numtide-llm-agents
    # numtide-llm-agents.url = "github:numtide/llm-agents.nix";
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # browsers
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # not following nixpkgs so builds keep hitting noctalia.cachix.org
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    rex.url = "https://pkgs.superlogical.com/rex/nix/snapshot.tar.gz";
    # zed-flake.url = "github:jamesbirtles/zed-flake/stable";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./modules)
      ];
    };
}
