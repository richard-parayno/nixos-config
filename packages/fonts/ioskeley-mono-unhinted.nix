{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "ioskeley-mono-unhinted";
  version = "1.0";

  src = ../../assets/fonts/IoskeleyMono-TTF-Unhinted.zip;

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.nerd-font-patcher
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 TTF-Unhinted/*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/fonts/truetype/{ioskeley-mono,ioskeley-mono-nerd}
    mv $out/share/fonts/truetype/*.ttf $out/share/fonts/truetype/ioskeley-mono/
    for f in $out/share/fonts/truetype/ioskeley-mono/*.ttf; do
      nerd-font-patcher --complete --outputdir $out/share/fonts/truetype/ioskeley-mono-nerd/ $f
    done
  '';
}
