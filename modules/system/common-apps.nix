{ self, inputs, ... }:
{
  flake.nixosModules.common-apps =
    { pkgs, ... }:
    let
      # Electron defaults to the unsupported/basic_text backend under Niri because
      # XDG_CURRENT_DESKTOP is "niri", even when gnome-keyring is available.
      # Force Element to use libsecret so it can use the running keyring.
      element-desktop-with-keyring =
        pkgs.runCommand "element-desktop-with-keyring"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
          }
          ''
            mkdir -p "$out/bin" "$out/share"
            cp -rs ${pkgs.element-desktop}/share/. "$out/share/"
            makeWrapper ${pkgs.element-desktop}/bin/element-desktop "$out/bin/element-desktop" \
              --add-flags "--password-store=gnome-libsecret"
          '';
    in
    {
      imports = [ inputs.codex-desktop-linux.nixosModules.default ];

      programs.codexDesktopLinux = {
        enable = true;
        computerUseUi.enable = true;
        remoteMobileControl.enable = true;
        remoteControl.enable = true;
      };

      environment.systemPackages = with pkgs; [
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
        slack
        telegram-desktop
        spotify
        libreoffice-qt
        obsidian
        logseq
        ytmdesktop
        bitwarden-desktop
        cinny-desktop
        element-desktop-with-keyring
        kdePackages.okular
        kdePackages.ark
        # zoom-us
        kora-icon-theme
        koreader
        themechanger
        catppuccin-kde
        catppuccin-kvantum
        kdePackages.oxygen
        kdePackages.oxygen-icons
        kdePackages.oxygen-sounds
        oxygenfonts
        kdePackages.qtstyleplugin-kvantum
        calibre
      ];

    };
}
