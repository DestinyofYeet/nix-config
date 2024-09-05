# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings = {
      substituters = [
        "https://cache.nixos.org/"
        "http://nix-server.infra.wg?priority=50"
      ];

      trusted-public-keys = [
        "nix-server.infra.wg:6NVrebwBuWHxZx8PNXQwgBHamQer7VcMBYxerF/xvr8="
      ];
  };

  networking.extraHosts = ''
    10.42.5.1 truenas.infra.wg
    127.0.0.1 nix-server.infra.wg
    10.42.5.3 ssh.nix-server.infra.wg
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

      WOL_DISABLE= "Y";
    };    
  };

  services.nginx = {
    enable = true;

    upstreams."nix_server" = {
      extraConfig = ''
        server 192.168.0.248:5000 max_fails=1 fail_timeout=10m;
        server 10.42.5.3:5000 backup;
      '';
    };

    virtualHosts."nix-server.infra.wg" = {
      serverName = "nix-server.infra.wg";
      listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];

      locations = {
        "/" = {
          proxyPass = "http://nix_server";
          extraConfig = ''
            proxy_connect_timeout 2s;
          '';
        };
      };
    };
  };
}
