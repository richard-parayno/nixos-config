{ self, inputs, ... }:
{
  flake.nixosModules.app-image =
    { pkgs, ... }:
    {
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
