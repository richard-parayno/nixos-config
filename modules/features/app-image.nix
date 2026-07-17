{ self, inputs, ... }:
{
  flake.nixosModules.app-image =
    { pkgs, ... }:
    {
      # add gearlever, a tool to help us integrate app images to the system
      environment.systemPackages = with pkgs; [
        gearlever
      ];
      # Direct execution of AppImages on NixOS
      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs =
            pkgs:
            (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
            ++ [
              pkgs.zstd
            ];
        };
      };
    };
}
