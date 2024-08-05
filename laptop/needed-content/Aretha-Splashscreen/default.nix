{
  stdenv
}:

stdenv.mkDerivation {
  name = "Aretha-Splash-6";
  version = "1.0";

  src = ./Aretha-Splash-6/;

  installPhase = ''
    mkdir -p $out/
    cp -r $in/ $out
  '';
}
