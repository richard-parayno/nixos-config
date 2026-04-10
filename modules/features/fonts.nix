{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.berkeley-mono = pkgs.callPackage ../../packages/fonts/berkeley-mono.nix { };
      packages.ioskeley-mono-hinted = pkgs.callPackage ../../packages/fonts/ioskeley-mono-hinted.nix { };
      packages.ioskeley-mono-unhinted =
        pkgs.callPackage ../../packages/fonts/ioskeley-mono-unhinted.nix
          { };
      packages.sf-pro = pkgs.callPackage ../../packages/fonts/sf-pro.nix { };
      packages.zenbones-mono-brainy = pkgs.callPackage ../../packages/fonts/zenbones-mono-brainy.nix { };
    };

  flake.nixosModules.fonts =
    { pkgs, ... }:
    let
      fontPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      fonts.packages = with pkgs; [
        noto-fonts
        recursive
        nerd-fonts.fira-code
        nerd-fonts.zed-mono
        nerd-fonts.recursive-mono
        nerd-fonts.geist-mono
        nerd-fonts.hack
        nerd-fonts.commit-mono
        nerd-fonts.iosevka
        nerd-fonts.symbols-only
        fontPkgs.berkeley-mono
        fontPkgs.zenbones-mono-brainy
        fontPkgs.ioskeley-mono-hinted
        fontPkgs.sf-pro
      ];

      fonts.fontDir.enable = true;
      fonts.enableDefaultPackages = true;
      fonts.fontconfig = {
        enable = true;
        antialias = true;
        hinting = {
          enable = true;
          autohint = false;
        };

        useEmbeddedBitmaps = true;

        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <!-- SF Pro: disable autohinting and use native CFF hinting so kerning metrics stay correct -->
            <match target="font">
              <test name="family" compare="contains">
                <string>SF Pro</string>
              </test>
              <edit name="autohint" mode="assign"><bool>false</bool></edit>
              <edit name="hinting" mode="assign"><bool>true</bool></edit>
              <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
              <edit name="antialias" mode="assign"><bool>true</bool></edit>
              <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
            </match>
          </fontconfig>
        '';

        defaultFonts = {
          sansSerif = [ "SF Pro Text" ];
          monospace = [
            "Berkeley Mono"
            "Symbols Nerd Font Mono"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
}
