{ 
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkgs,
}: 

rustPlatform.buildRustPackage rec {
  pname = "clean_unused_files";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "DestinyofYeet";
    repo = pname;
    rev = "7133a549552629703cf890872c45e73c0a161ecb";
    hash = "sha256-AWv+LEadDRgT1TN2zNs2ARAf8kcUm3kWgu61f5lx11M=";
  };

  cargoHash = "sha256-Yk/GLdXi510foEyn/g9bijhugJ0vopsBMlfezHj0UCI=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl.dev
  ];

  # stupid openssl bulshit
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A tool to automatically remove unused files from qbittorrent";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
