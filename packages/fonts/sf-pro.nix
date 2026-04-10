{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "sf-pro";
  version = "1.0";

  src = ../../assets/fonts/SFPro.zip;

  nativeBuildInputs = [
    pkgs.unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype/SFPro
    install -m644 */*.otf $out/share/fonts/opentype/SFPro/

    runHook postInstall
  '';
}
