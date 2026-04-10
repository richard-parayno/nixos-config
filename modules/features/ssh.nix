{ self, inputs, ... }:
{
  flake.nixosModules.ssh =
    { pkgs, ... }:
    {
      services.openssh.enable = true;
      services.openssh.extraConfig = ''
        ClientAliveInterval 60
        ClientAliveCountMax 120
      '';

      programs.mosh.enable = true;
      programs.mosh.openFirewall = true;

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-qt;
        enableSSHSupport = true;
      };
    };
}
