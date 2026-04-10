{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "kitasan-black-cursor";
  version = "1.0";

  src = ../../assets/cursors/UmaCursor_Kitasan.tar.gz;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Kitasan-Black
    cp -r * $out/share/icons/Kitasan-Black/

    runHook postInstall
  '';

  meta = {
    description = "Kitasan Black cursor theme from Umamusume";
    platforms = pkgs.lib.platforms.all;
  };
}
