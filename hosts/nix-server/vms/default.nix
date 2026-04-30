{
  flake,
  pkgs,
  inputs,
  config,
  lib,
  secretStore,
  ...
}:
let

  mkVM = lib.custom.vm.getMkVm {
    inherit pkgs flake config;
    gateway = "192.168.3.1";
    dns = [
      "192.168.3.1"
      "9.9.9.9"
    ];
  };

  secrets = secretStore.getHostSecrets "nix-server";

  forgejo-vm-name = "forgejo";

in
{
  imports = [ ./nginx.nix ];

  age.secrets = {
    forgejo-runner-host-key = {
      file = secrets.getSecret "vm-forgejo-runner-hostkey";
      path = "${config.microvm.stateDir}/${forgejo-vm-name}/persistent/hostkey";
      symlink = false;
    };

    forgejo-runner-host-key-rsa = {
      file = secrets.getSecret "vm-forgejo-runner-hostkey-rsa";
      path = "${config.microvm.stateDir}/${forgejo-vm-name}/persistent/hostkey-rsa";
      symlink = false;
    };

    ha-hostkey-ed25519 = {
      file = secrets.getSecret "vm-ha-hostkey-ed25519";
      path = "${config.microvm.stateDir}/ha-vm/root/persistent/hostkey";
      symlink = false;
    };

    ha-hostkey-rsa = {
      file = secrets.getSecret "vm-ha-hostkey-rsa";
      path = "${config.microvm.stateDir}/ha-vm/root/persistent/hostkey-rsa";
      symlink = false;
    };
  };

  microvm = {
    host.enable = true;
    stateDir = "/mnt/data/data/microvms";

    vms = lib.mkMerge [
      (mkVM "rofl" {
        ip = "192.168.3.10";
        mac = "02:00:00:00:00:01";
        config = {
          imports = [
            ./rofl
            ./baseline
          ];
        };
      })

      (mkVM forgejo-vm-name {
        ip = "192.168.3.11";
        mac = "02:00:00:00:00:02";
        config = {
          imports = [
            ./baseline
            ./forgejo-runner
            inputs.agenix.nixosModules.default
          ];
        };
      })

      (mkVM "ha-vm" {
        ip = "192.168.3.12";
        mac = "02:00:00:00:00:03";
        config = {
          networking.hostName = "nix-server-ha-vm";
          imports = [
            ./baseline
            ./ha-vm
            inputs.agenix.nixosModules.default
            ../../../baseline/nebula.nix
            ../../../options/capabilities/options.nix
            ../../parts/ha-vm
          ];

          services.nginx.enable = true;

          capabilities = {
            hardware.headless.enable = true;
          };
        };
      })
    ];
  };
}
