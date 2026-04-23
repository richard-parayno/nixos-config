{ self, inputs, ... }:
{
  flake.nixosModules.browser =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        google-chrome
        vivaldi
        floorp-bin
        inputs.helium.packages.${stdenv.hostPlatform.system}.default # helium
        inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default # zen-browser
      ];

      programs.firefox.enable = true;
    };
}
