{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.kitasan-black = pkgs.callPackage ../../../packages/kitasan-black { };
    };

  flake.nixosModules.cursor = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.kitasan-black
    ];
  };

  flake.homeModules.cursor =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "Kitasan-Black";
        size = 40;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.kitasan-black;
      };

      # Plasma's cursor settings rewrite this file as a real (read-only) file,
      # which made every home-manager activation fail with "would be clobbered".
      xdg.dataFile."icons/default/index.theme".force = true;
    };
}
