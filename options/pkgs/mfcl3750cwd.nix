/* This is mostly copied straight from:
   https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/misc/cups/drivers/brother/mfcl3770cdw/default.nix

   I only had to change the model, the URL, the hash, and one occurence of the original model string
   being used instead of the variable.

   I'll try to upstream this after some testing.
*/

{ pkgsi686Linux, stdenv, fetchurl, dpkg, makeWrapper, coreutils, ghostscript
, gnugrep, gnused, which, perl, lib }:

let
  model = "mfcl3750cdw";
  version = "1.0.2-0";
  src = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf103934/${model}pdrv-${version}.i386.deb";
    sha256 = "sha256-Og1fCaJlII/dG4Jm7zYobsKUx6S++jJ76BFB76voWQs=";
  };
  reldir = "opt/brother/Printers/${model}/";

in rec {
  driver = pkgsi686Linux.stdenv.mkDerivation rec {
    inherit src version;
    name = "${model}drv-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
        dir="$out/${reldir}"
        substituteInPlace $dir/lpd/filter_${model} \
          --replace /usr/bin/perl ${perl}/bin/perl \
          --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
          --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
        wrapProgram $dir/lpd/filter_${model} \
          --prefix PATH : ${
            lib.makeBinPath [ coreutils ghostscript gnugrep gnused which ]
          }
      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $dir/lpd/br${model}filter
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ ];
    };
  };

  cupswrapper = stdenv.mkDerivation rec {
    inherit version src;
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [ dpkg makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "basedir =~" "basedir = \"$basedir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
        --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
      ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "http://www.brother.com/";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.gpl2;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ ];
    };
  };
}

