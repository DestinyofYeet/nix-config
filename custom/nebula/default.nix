{ lib, ... }:
let
  networkName = "yeet";

  machines = import ./machines.nix;

  genStaticHostMap = machines:
    builtins.listToAttrs (map (entry: {
      name = entry.value.ip;
      value = entry.value.external_ips;
    }) (builtins.filter (attr: attr.value.lighthouse or false)
      (lib.attrsToList machines)));

  getLighthouses = machines:
    lib.mapAttrsToList (_v: v: v.ip)
    (lib.filterAttrs (name: value: value.lighthouse or false) machines);

  genFilteredStaticHostMap = machines: currentNode:
    lib.attrsets.filterAttrs (key: value: key != currentNode.ip)
    (genStaticHostMap machines);
in rec {
  yeet = {
    staticHostMap = genStaticHostMap machines;
    lightHouses = getLighthouses machines;

    hosts = import ./machines.nix;
  };

  getConfig = lib: config:
    let
      currentName = config.networking.hostName;
      currentNode = yeet.hosts.${currentName};
      isLightHouse = currentNode.lighthouse or false;
    in {
      age.secrets = {
        "nebula-${currentName}-priv" = rec {
          file = currentNode.privKeyFile;
          owner = "nebula-${networkName}";
          group = owner;
        };
      };

      services.nebula.networks.${networkName} = {
        enable = true;
        key = config.age.secrets."nebula-${currentName}-priv".path;
        cert = currentNode.publicKeyFile;
        ca = ./ca.crt;

        staticHostMap = if (!isLightHouse) then
          yeet.staticHostMap
        else
          (genFilteredStaticHostMap machines currentNode);
        lighthouses = lib.mkIf (!isLightHouse) yeet.lightHouses;

        isLighthouse = isLightHouse;
        listen = lib.mkIf isLightHouse {
          host = "0.0.0.0";
          port = 4242;
        };

        settings = { punchy.punch = lib.mkIf (!isLightHouse) true; };

        firewall = rec {
          inbound = [{
            host = "any";
            port = "any";
            proto = "any";
          }];

          outbound = inbound;
        };
      };

      networking.firewall = {
        allowedUDPPorts = lib.mkIf isLightHouse [ 4242 ];
        trustedInterfaces = [ "nebula.${networkName}" ];
      };
    };
}
