# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings = {
      substituters = [
        "https://cache.nixos.org/"
        "http://nix-server.infra.wg:5000?priority=50"
      ];

      trusted-public-keys = [
        "nix-server.infra.wg:6NVrebwBuWHxZx8PNXQwgBHamQer7VcMBYxerF/xvr8="
      ];
  };

  networking.extraHosts = ''
    10.42.5.3 nix-server.infra.wg
    10.42.5.1 truenas.infra.wg
  '';

  # disable baloo
   environment = {
    etc."xdg/baloofilerc".source = (pkgs.formats.ini {}).generate "baloorc" {
      "Basic Settings" = {
        "Indexing-Enabled" = false;
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    baloo # fuck this shit
  ];
}
