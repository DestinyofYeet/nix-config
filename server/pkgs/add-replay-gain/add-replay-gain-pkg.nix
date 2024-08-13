{ 
  fetchFromGitHub,
  rustPlatform,
}: 

rustPlatform.buildRustPackage rec {
  pname = "add_replay_gain_to_files";
  version = "1.0";

  src = fetchFromGitHub {
    rev = "v${version}";

    owner = "DestinyofYeet";
    repo = "add_replay_gain";

    hash = "sha256-CLCwabsAOoaYnckratlekg3RGsVxR4dsw9TWlIyGOtQ=";
  };

  cargoHash = "sha256-bvxHtMFbwRPePXvCYdsMNNkZwIcoOAGVAgYCbb0GESQ=";

  meta = with rustPlatform.meta; {
    description = "A tool to automatically add replay gain to mp3 and flac files";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
