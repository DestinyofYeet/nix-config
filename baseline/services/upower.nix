{ lib, config, ... }:
lib.mkIf (config.capabilities.battery.enable) { services.upower.enable = true; }
