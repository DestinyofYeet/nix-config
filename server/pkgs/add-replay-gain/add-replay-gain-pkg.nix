{ 
  rustPlatform,
  lib,
  fetchzip,
}: 

rustPlatform.buildRustPackage rec {
  pname = "add_replay_gain_to_files";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/DestinyofYeet/add_replay_gain/archive/4954d457b5cf7bd0623735bfb7966d55ce1cb0be.zip";
    hash = "sha256-TeUZxu8JbCsVjoUofL0fI6aPcfsDj13KL+UFN6QAr8A=";
  };

  cargoHash = "sha256-KFMOF22nMW9iEf0z0mAcLdOz8YPaMvk7b2+C8bA2XAk=";

  meta = with lib; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
