{
  lib,
  config,
  inputs,
  ...
}:
(lib.mkIf (!config.capabilities.customNixInterpreter.enable) {
})
