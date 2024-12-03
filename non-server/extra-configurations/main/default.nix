# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  gaming-pkgs = with pkgs; [
    gamescope
    mangohud
    amdvlk
    gamemode
    vkbasalt
  ];
in
{
  nix.settings = {
      substituters = [
        "http://cache.nix-server.infra.wg:5000?priority=30"
      ];

      trusted-public-keys = [
        "cache.nix-server.infra.wg:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg="
      ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  programs.steam.extraPackages = gaming-pkgs;

  programs.gamemode.enable = true;

  networking.extraHosts = ''
    192.168.0.250 nix-server.infra.wg
  '';

  environment.systemPackages = with pkgs; [
    vulkan-tools
    goverlay
  ] ++ gaming-pkgs;

  services.postgresql = {
    enable = false;
    ensureDatabases = [
      "strichliste-rs"
    ];

    ensureUsers = [
        {
          name = "strichliste-rs";
          ensureDBOwnership = true;
        }
    ];
  };

  nix.buildMachines = [
    {
      hostName = "teapot";
      system = "x86_64-linux";
      protocol = "ssh";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.distributedBuilds = true;

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
