{ lib, capabilities, ... }:
lib.mkIf (capabilities.battery.enable) { services.upower.enable = true; }
