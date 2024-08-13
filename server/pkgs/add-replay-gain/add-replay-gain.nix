{ config, lib, pkgs, ... }:

# Examples:
# https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/torrent/deluge.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/misc/jellyfin.nix

with lib;

let 
  cfg = config.services.add-replay-gain;

in 
{
  options = {
    services.auto-add-replay-gain = {
      enable = mkEnableOption "Add replay gain to files";

      package = mkPackageOption pkgs.callPackage ./add-replay-gain-pkg.nix {};
    };
  };  
}
