{ self, inputs, ... }:
{
  flake.nixosModules.browser =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        google-chrome
        inputs.helium.packages.${stdenv.hostPlatform.system}.default # helium
        inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default # zen-browser
      ];

      programs.firefox.enable = true;

      programs.captive-browser.enable = true;
      programs.captive-browser.interface = "wlp0s20f3";
    };
}
