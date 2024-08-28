{ 
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkgs,
}: 

rustPlatform.buildRustPackage rec {
  pname = "clean_unused_files";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "DestinyofYeet";
    repo = pname;
    rev = "294f08b7c519bba3820503da0b11b348488181d8";
    hash = "sha256-v3a4DhKp6RVYDM/3Impn3tD4JxEKJ971bTtVcdTE2qg=";
  };

  cargoHash = "sha256-KHjGTGlispszQQy75Gb1wPCDKYTJbCk0r2ySh9bdFHc=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl.dev
  ];

  # stupid openssl bulshit
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
