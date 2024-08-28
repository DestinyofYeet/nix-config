{ 
  rustPlatform,
  lib,
  fetchzip,
  pkgs,
}: 

rustPlatform.buildRustPackage rec {
  pname = "add_replay_gain_to_files";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/DestinyofYeet/add_replay_gain/archive/d6f7d191a98e003e18e8657ccab5cd8f221715d5.zip";
    hash = "sha256-0YoXg0vYpjDezEJPkjmnp/UY57TcZ8JAVgYn0XNvfts=";
  };

  cargoHash = "sha256-1kylTyFGZHO5ypHw1a9Ma8G30ziMKkSRQdYsY23RIIs=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl.dev
  ];

  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  meta = with lib; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    # maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
