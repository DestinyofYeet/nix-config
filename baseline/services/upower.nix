{ lib, config, ... }:
lib.mkIf (config.capabilities.hardware.battery.enable) { services.upower.enable = true; }
