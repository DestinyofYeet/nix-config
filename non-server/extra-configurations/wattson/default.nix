# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }: {
  imports = [
    ./38C3.nix
    ./vpn.nix
    ./agenix.nix
    # ./prost.nix
    # ./postgres.nix
    # ./docker-compose.nix
    ./strichliste.nix
    ./swap.nix
    ../kanata.nix
  ];

  nix = {
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    buildMachines = [
      # {
      #   hostName = "fsim-builder";
      #   system = "x86_64-linux";
      #   protocol = "ssh";
      #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      #   mandatoryFeatures = [ ];
      # }
      {
        hostName = "teapot";
        system = "x86_64-linux";
        protocol = "ssh";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
        maxJobs = 6;
        speedFactor = 2;
      }
      {
        hostName = "bonk";
        system = "x86_64-linux";
        protocol = "ssh";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
        maxJobs = 6;
        speedFactor = 2;
      }
    ];

    distributedBuilds = true;

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  networking.extraHosts = ''
    10.42.5.1 truenas.infra.wg
    127.0.0.1 cache.nix-server.infra.wg
    10.42.5.3 nix-server.infra.wg
    10.42.5.3 engelsystem.nix-server.infra.wg
    10.42.5.3 firefly.nix-server.infra.wg
    10.42.5.3 passbolt.nix-server.infra.wg
  '';

  # disable baloo
  environment = {
    etc."xdg/baloofilerc".source = (pkgs.formats.ini { }).generate "baloorc" {
      "Basic Settings" = { "Indexing-Enabled" = false; };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages;
    [
      baloo # fuck this shit
    ];

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      DISK_IDLE_SECS_ON_BAT = 2;
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";

      AHCI_RUNTIME_PM_ON_AC = "auto";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      AHCI_RUNTIME_PM_TIMEOUT = "";

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";

      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";

      RADEON_POWER_PROFILE_ON_AC = "high";
      RADEON_POWER_PROFILE_ON_BAT = "low";

      WOL_DISABLE = "Y";
    };
  };

  # services.nginx = {
  #   enable = true;

  #   upstreams."nix_server" = {
  #     extraConfig = ''
  #       server 192.168.0.250:5000 max_fails=1 fail_timeout=10m;
  #       server 10.42.5.3:5000 backup;
  #     '';
  #   };

  #   virtualHosts."cache.nix-server.infra.wg" = {
  #     serverName = "cache.nix-server.infra.wg";
  #     listen = [
  #       {
  #         addr = "127.0.0.1";
  #         port = 80;
  #       }
  #     ];

  #     locations = {
  #       "/" = {
  #         proxyPass = "http://nix_server";
  #         extraConfig = ''
  #           proxy_connect_timeout 2s;
  #         '';
  #       };
  #     };
  #   };
  # };

  services.fwupd.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  services.logind.powerKey = "suspend";
}
