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
        gtk.enable = true;
        x11.enable = true;
        name = "Kitasan-Black";
        size = 40;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.kitasan-black;
      };
    };
}
