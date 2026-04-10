{ self, inputs, ... }:
{
  flake.nixosModules.common-apps =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        discord
        vesktop
        telegram-desktop
        spotify
        libreoffice-qt
        obsidian
        ytmdesktop
        bitwarden-desktop
      ];

    };
}
