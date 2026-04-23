{ pkgs, ... }:
{
  flake.homeModules.flameshot =
    { ... }:
    {
      services.flameshot = {
        enable = true;
        settings = {
          General = {
            savePath = "/home/richard/Screenshots";
            saveAsFileExtension = ".png";
            showDesktopNotification = true;
            useGrimAdapter = true;
            disabledGrimWarning = true;
          };
        };
      };
    };

  flake.nixosModules.flameshot =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        grim
        flameshot
      ];
    };
}
