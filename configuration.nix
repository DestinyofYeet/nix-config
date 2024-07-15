# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      # No touchey !!!
      # Since Nix runs in a systemd-nspawn environment, it doesn't boot without this
      "${modulesPath}/virtualisation/lxc-container.nix"

      ./system_packages.nix
      ./system_users.nix
      ./system_services.nix
      ./home_manager.nix
    ];

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  networking.firewall = {
		enable = true;
		allowedTCPPorts = [80 443];
	};
}
