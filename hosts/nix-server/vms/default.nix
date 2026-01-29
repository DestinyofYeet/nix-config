{ flake, pkgs, inputs, config, lib, secretStore, ... }:
let

  mkVM = lib.custom.vm.getMkVm {
    inherit pkgs flake config;
    gateway = "192.168.3.1";
    dns = [ "192.168.3.1" "9.9.9.9" ];
  };

  secrets = secretStore.getServerSecrets "nix-server";

  forgejo-vm-name = "forgejo";

in {
  imports = [ ./nginx.nix ];

  age.secrets = {
    forgejo-runner-host-key = {
      file = secrets + "/vm-forgejo-runner-hostkey.age";
      path = "${config.microvm.stateDir}/${forgejo-vm-name}/persistent/hostkey";
      symlink = false;
    };

    forgejo-runner-host-key-rsa = {
      file = secrets + "/vm-forgejo-runner-hostkey-rsa.age";
      path =
        "${config.microvm.stateDir}/${forgejo-vm-name}/persistent/hostkey-rsa";
      symlink = false;
    };

    ha-hostkey-ed25519 = {
      file = secrets + "/vm-ha-hostkey-ed25519.age";
      path = "${config.microvm.stateDir}/ha-vm/root/persistent/hostkey";
      symlink = false;
    };

    ha-hostkey-rsa = {
      file = secrets + "/vm-ha-hostkey-rsa.age";
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
        config = { imports = [ ./rofl ./baseline ]; };
      })

      (mkVM forgejo-vm-name {
        ip = "192.168.3.11";
        mac = "02:00:00:00:00:02";
        config = {
          imports =
            [ ./baseline ./forgejo-runner inputs.agenix.nixosModules.default ];
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

          capabilities = { headless.enable = true; };
        };
      })
    ];
  };
}
