{ functions, ... }@inputs:
let importFolder = functions.getImportFolder ./.;
in (importFolder "ha-vm/" inputs)
