{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "zenbones-mono-brainy";
  version = "1.0";

  src = ../../assets/fonts/Zenbones-Brainy-TTF.zip;

  nativeBuildInputs = [ pkgs.unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 TTF/*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';
}
