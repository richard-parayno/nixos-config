{ self, inputs, ... }:
{
  flake.nixosModules.common-apps =
    { pkgs, ... }:
    let
      # Electron defaults to the unsupported/basic_text backend under Niri because
      # XDG_CURRENT_DESKTOP is "niri", even when gnome-keyring is available.
      # Force Element to use libsecret so it can use the running keyring.
      element-desktop-with-keyring = pkgs.runCommand "element-desktop-with-keyring" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
        mkdir -p "$out/bin" "$out/share"
        cp -rs ${pkgs.element-desktop}/share/. "$out/share/"
        makeWrapper ${pkgs.element-desktop}/bin/element-desktop "$out/bin/element-desktop" \
          --add-flags "--password-store=gnome-libsecret"
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        discord
        vesktop
        slack
        telegram-desktop
        spotify
        libreoffice-qt
        obsidian
        ytmdesktop
        bitwarden-desktop
        cinny-desktop
        element-desktop-with-keyring
      ];

    };
}
