{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  mkBoolOption = default: desc:
    mkOption {
      inherit default;
      type = types.bool;
      description = "Wether " + desc;
    };

  cfg = config.capabilities;
in {
  options = {
    capabilities = {
      headless.enable = mkBoolOption false "this host is headless";
      monitor.enable = mkBoolOption false "this host has a monitor";
      touch.enable = mkBoolOption false "this host has a touch monitor";
      battery.enable = mkBoolOption false "this host has a battery";
      bluetooth.enable = mkBoolOption false "this host has bluetooth";
      wifi.enable = mkBoolOption false "this host has wifi";

      customNixInterpreter.enable =
        mkBoolOption true "to use a custom nix interpreter";
      nebulaVpn.enable = mkBoolOption true "to use the nebulaVpn";
      agenix.enable = mkBoolOption true "to use agenix";
      wavesurfer-ld.enable =
        mkBoolOption false "to enable nix-ld to use wavesurfer";
      strict-networking.enable =
        mkBoolOption false "to enable strict firewall rules";
    };

  };

  config.assertions = [{
    assertion = cfg.headless.enable != cfg.monitor.enable;
    message = "You cannot have a monitor and be headless at the same time!";
  }];

}
