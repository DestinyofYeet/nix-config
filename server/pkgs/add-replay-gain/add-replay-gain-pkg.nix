{ 
  rustPlatform,
  lib,
  fetchzip,
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

  src = fetchzip {
    url = "https://github.com/DestinyofYeet/add_replay_gain/archive/00649d11166476d0557f98a3a0ef559ff7f31861.zip";
    hash = "sha256-M/ykbeuBUSe41rfB0lucsHoSr6bKCSSVkOepY7i35Rk=";
  };

  cargoHash = "sha256-WCo8S4BwEW8X4DxJbTbSiRBwUap89hWA9ivohyPEpqY=";

  meta = with lib; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
