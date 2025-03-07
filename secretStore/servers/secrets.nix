{ keys }:
let functions = import ../functions.nix { path = ./.; };
in (functions.importFolder "nix-server/" { inherit keys; })
// (functions.importFolder "teapot/" { inherit keys; })
// (functions.importFolder "bonk/" { inherit keys; })
