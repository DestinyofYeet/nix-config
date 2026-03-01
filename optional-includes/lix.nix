{ lib, config, ... }:
(lib.mkIf (!config.capabilities.customNixInterpreter.enable) {
  lix.enable = (lib.mkForce false);
})
