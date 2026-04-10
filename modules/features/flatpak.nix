{ self, inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, lib, ... }:
    {

      services.flatpak.enable = true;
      services.flatpak.remotes = lib.mkOptionDefault [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      services.flatpak.packages = [
        "com.github.tchx84.Flatseal"
      ];
    };
}
