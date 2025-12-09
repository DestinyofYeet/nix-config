{ config, lib, custom, ... }:
lib.mkIf (config.capabilities.nebulaVpn.enable)
(custom.nebula.getConfig lib config)
