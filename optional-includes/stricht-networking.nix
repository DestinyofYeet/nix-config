{ lib, config, ... }:
lib.mkIf (config.capabilities.strict-networking.enable) {

  networking.firewall.enable = lib.mkForce true;

  networking.firewall.allowedTCPPortRanges = lib.mkForce [ ];
  networking.firewall.allowedUDPPortRanges = lib.mkForce [ ];
  networking.firewall.allowedTCPPorts = lib.mkForce [ ];
  networking.firewall.allowedUDPPorts = lib.mkForce [ ];
}
