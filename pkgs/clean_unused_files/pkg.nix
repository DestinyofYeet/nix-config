{ 
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkgs,
}: 

rustPlatform.buildRustPackage rec {
  pname = "clean_unused_files";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "DestinyofYeet";
    repo = pname;
    rev = "ba6da58217dabcc56a9ba9f744ff6ebb0f738445";
    hash = "sha256-1iYk2SPh7iFoHK/ndcqYAIkkQEWSVJJlgpCCW4TCKoo=";
  };

  cargoHash = "sha256-k8QL8qJTZx6p7EwFDbLtt+Bd46zfnKgjC+0/ydHaudg=";

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
