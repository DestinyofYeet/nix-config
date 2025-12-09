{ lib, ... }:
let
  inherit (lib) mkOption types;
  mkBoolOption = default: desc:
    mkOption {
      inherit default;
      type = types.bool;
      description = "Wether " + desc;
    };
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
    };
  };
}
