{ lib, config, ... }:
(lib.mkIf (config.capabilities.customNixInterpreter.enable) {
  lix.enable = (builtins.trace "Enabling lix" (lib.mkForce true));
})
