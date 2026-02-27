{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  mkBoolOption =
    default: desc:
    mkOption {
      inherit default;
      type = types.bool;
      description = "Wether " + desc;
    };

  cfg = config.capabilities;
in
{
  options = {
    capabilities = {
      hardware = {
        headless.enable = mkBoolOption false "this host is headless";
        monitor.enable = mkBoolOption false "this host has a monitor";
        touch.enable = mkBoolOption false "this host has a touch monitor";
        battery.enable = mkBoolOption false "this host has a battery";
        bluetooth.enable = mkBoolOption false "this host has bluetooth";
        wifi.enable = mkBoolOption false "this host has wifi";
        keyboardBacklight.enable = mkBoolOption false "this host has keyboard backlight";
      };

      customNixInterpreter.enable = mkBoolOption true "to use a custom nix interpreter";
      nebulaVpn.enable = mkBoolOption true "to use the nebulaVpn";
      agenix.enable = mkBoolOption true "to use agenix";
      wavesurfer-ld.enable = mkBoolOption false "to enable nix-ld to use wavesurfer";
      strict-networking.enable = mkBoolOption false "to enable strict firewall rules";
      wallpaperEngine.enable = mkBoolOption false "to use the wallpaper engine instead of images";
    };

  };

  config.assertions = [
    {
      assertion = cfg.hardware.headless.enable != cfg.hardware.monitor.enable;
      message = "You cannot have a monitor and be headless at the same time!";
    }
  ];

}
