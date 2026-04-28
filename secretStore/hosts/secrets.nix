{ keys, functions, lib, ... }@inputs:
let importFolder = functions.getImportFolder ./.;

in (importFolder "nix-server/" inputs) // (importFolder "teapot/" inputs)
// (importFolder "bonk/" inputs) // (importFolder "common/" inputs)
