{ flake, pkgs, inputs, config, lib, secretStore, ... }:
let
  mkVM = name: settings: {
    "${name}" = {
      pkgs = settings.pkgs or pkgs;
      specialArgs = flake.defaultSpecialArgs;
      config = lib.mkMerge [
        {
          microvm = {
            interfaces = [{
              type = "tap";
              id = "vm-${name}";
              mac = settings.mac;
            }];
          };

          system.stateVersion = config.system.stateVersion;

          networking.useNetworkd = false;
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Name = "enp*";
              networkConfig = {
                Address = [ "${settings.ip}/24" ];
                Gateway = "192.168.3.1";
                DNS = [ "192.168.3.1" "9.9.9.9" ];
                IPv6AcceptRA = true;
                DHCP = "no";
              };
            };
          };
          networking.useDHCP = lib.mkForce false;
        }

        settings.config
      ];
    };
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
        mac = "02:00:00:00:00:12";
        config = {
          imports = [ ./baseline ./ha-vm inputs.agenix.nixosModules.default ];
        };
      })
    ];
  };
}
