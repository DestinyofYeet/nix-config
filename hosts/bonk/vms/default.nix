{ lib, pkgs, flake, config, inputs, secretStore, ... }:
let
  mkVM = lib.vm.getMkVm {

    inherit pkgs flake config;
    gateway = "192.168.3.1";
    dns = [ "192.168.3.1" "9.9.9.9" ];
  };

  secrets = secretStore.getServerSecrets "bonk";
in {

  age.secrets = {
    # need to create root/persistent folder manually manually
    ha-host-key = {
      file = secrets + "/vm-ha-hostkey-ed25519.age";
      path = "${config.microvm.stateDir}/ha-vm/root/persistent/hostkey";
      symlink = false;
    };

    ha-host-key-rsa = {
      file = secrets + "/vm-ha-hostkey-rsa.age";
      path = "${config.microvm.stateDir}/ha-vm/root/persistent/hostkey-rsa";
      symlink = false;
    };
  };

  microvm = {
    vms = lib.mkMerge [
      (mkVM "ha-vm" {
        ip = "192.168.3.10";
        mac = "02:00:00:00:00:01";
        config = {
          networking.hostName = "bonk-ha-vm";
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
