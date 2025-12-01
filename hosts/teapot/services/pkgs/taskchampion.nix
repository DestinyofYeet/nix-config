{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage {
  pname = "taskchampion-sync-server";
  version = "v0.5.0";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskchampion-sync-server";
    rev = "26e4e6c844546dcba8382eda3e38d01ff21d2cf9";
    fetchSubmodules = false;
    hash = "sha256-uOlubcQ5LAECvQEqgUR/5aLuDGQrdHy+K6vSapACmoo=";
  };

  cargoHash = "sha256-zpb0xPYq4qyIWKSfnwvc3Wld5nY3LmIrhRHjFtGVfPg=";

  checkType = "debug";

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    # maintainers = with lib.maintainers; [ mlaradji ];
    mainProgram = "taskchampion-sync-server";
  };
}
