{ functions, ... }@inputs:
let importFolder = functions.getImportFolder ./.;
in (importFolder "forgejo-runner/" inputs)
