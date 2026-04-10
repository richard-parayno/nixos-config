{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "1.0";

  src = ../../assets/fonts/berkeley-mono-slashed.zip;

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.nerd-font-patcher
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 */*/*.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/fonts/opentype/{berkeley-mono,berkeley-mono-nerd}
    mv $out/share/fonts/opentype/*.otf $out/share/fonts/opentype/berkeley-mono/
    for f in $out/share/fonts/opentype/berkeley-mono/*.otf; do
      nerd-font-patcher --single-width-glyphs --adjust-line-height --complete --outputdir $out/share/fonts/opentype/berkeley-mono-nerd/ $f
    done
  '';
}
