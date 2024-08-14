{ 
  fetchFromGitHub,
  rustPlatform,
  lib,
}: 

rustPlatform.buildRustPackage rec {
  pname = "add_replay_gain_to_files";
  version = "1.2";

  #src = fetchFromGitHub {
  #  rev = "v${version}";

  #  owner = "DestinyofYeet";
  #  repo = "add_replay_gain";

  #  hash = "sha256-hDOpIcz+OAWa+sH/kMqA4gcCdo7/aVf8pyslWhXenLY=";
  #};

  src = fetchTarball {
    url = "https://github.com/DestinyofYeet/add_replay_gain/archive/refs/tags/v1.2.tar.gz";
    sha256 = "0rp0grzl6szyzcda3lzn76w21vab9pl63v95lbsx3x95xg2dpkgp";
  };

  cargoHash = "sha256-WCo8S4BwEW8X4DxJbTbSiRBwUap89hWA9ivohyPEpqY=";

  meta = with lib; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
