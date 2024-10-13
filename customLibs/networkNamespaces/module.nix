self: { lib, config, pkgs, ... }:

with lib;

let 
  cfg = config.customLibs.networkNamespaces;
in {
  options = {
    customLibs.networkNamespaces = {
      enable = mkEnableOption "enable all network namespaces";

      spaces = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkEnableOption "enable this network namespace";

          
            name = mkOption {
              type = types.str;
              description = "The name of the network namespace";
              default = "";
            };

            description = mkOption {
              type = types.str;
              description = "The description of the network namespace";
              default = "";
            };

            wireguardConfigPath = mkOption {
              type = types.str;
              description = "The path to the wiregard config";
            };

            upholdsServices = mkOption {
              type = with types; listOf str;
              description = "The network namespace upholds the specified services";
              default = [];
            };

            networkIpIn = mkOption {
              type = types.str;
              description = "The ip to connect to the namespace";
            };

            networkIpOut = mkOption {
              type = types.str;
              description = "The ip to connect from the namespace to the host system";
            };

            iptableChains = mkOption {
              type = with types; listOf str;
              description = "A list of chains to create and delete";
              default = [];
            };
          };
        });
      };
    };
  };

  config = let

    build-namespace = name : namespaceConfig : let
      nsName = (if namespaceConfig.name != "" then namespaceConfig.name else name);
    in {
      wantedBy = [ "multi-user.target" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      upholds = mkIf (namespaceConfig.upholdsServices != null) namespaceConfig.upholdsServices;

      onFailure = [ "namespace-${nsName}-failure.service" ];

      unitConfig = {
        ConditionPathExists = "!/var/run/netns/${nsName}";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "true";
        ExecStartPre = "${pkgs.bash}/bin/sh -c 'until /run/current-system/sw/bin/host \$(${pkgs.coreutils}/bin/cat ${namespaceConfig.wireguardConfigPath} | ${pkgs.gnugrep}/bin/grep Endpoint | ${pkgs.gawk}/bin/awk \"{print \\$3}\" | ${pkgs.gnused}/bin/sed \"s/:.*//g\"); do sleep 1; done'";
        ExecStart = pkgs.writeScript "${nsName}-ns-isolation" ''
          #!${pkgs.bash}/bin/bash
            set -e
            export PATH=${pkgs.iproute}/bin:${pkgs.wireguard-tools}/bin:${pkgs.nettools}/bin:${pkgs.iptables}/bin:$PATH
            ip netns add ${nsName}
            ip netns exec ${nsName} ip link set dev lo up
            ip link add ${nsName}-wg0 type wireguard
            ip link set ${nsName}-wg0 netns ${nsName}
            ip -n ${nsName} addr add $(${pkgs.coreutils}/bin/cat ${namespaceConfig.wireguardConfigPath} | ${pkgs.gnugrep}/bin/grep Address | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.gnused}/bin/sed 's/,.*$//') dev ${nsName}-wg0
            ip netns exec ${nsName} wg syncconf ${nsName}-wg0 <(${pkgs.wireguard-tools}/bin/wg-quick strip ${namespaceConfig.wireguardConfigPath})
            ip -n ${nsName} link set ${nsName}-wg0 up
            ip -n ${nsName} route add default dev ${nsName}-wg0

            ip link add ${nsName}-veth0 type veth peer name ${nsName}-veth1
            ip link set ${nsName}-veth1 netns ${nsName}
            ip netns exec ${nsName} ifconfig ${nsName}-veth1 ${namespaceConfig.networkIpIn}/24 up
            ifconfig ${nsName}-veth0 ${namespaceConfig.networkIpOut}/24 up
            ip netns exec ${nsName} ip link set dev lo up

            # route all traffic from the local port 8080 to the namespace port 8080, so we can access the webinterface
            ${concatStringsSep "\n" (map (chain: "iptables -t nat -A" + chain) namespaceConfig.iptableChains)}
            # iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.1.1.1:8080
            # iptables -t nat -A POSTROUTING -j MASQUERADE
        '';

        ExecStop = pkgs.writeScript "${nsName}-ns-isolation-stop" ''
          #!${pkgs.bash}/bin/bash
          set -e
          export PATH=${pkgs.iproute}/bin:${pkgs.iptables}/bin:$PATH
          ip netns delete ${nsName}
          # iptables -t nat -D PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.1.1.1:8080
          # iptables -t nat -D POSTROUTING -j MASQUERADE
          ${concatStringsSep "\n" (map (chain: "iptables -t nat -D" + chain) namespaceConfig.iptableChains)}
          ip link delete ${nsName}-veth0 
        '';
      };
    };

  build-namespace-failure = name : namespaceConfig : let
    nsName = (if namespaceConfig.name != "" then namespaceConfig.name else name);
  in {
      description = "Delete and clean up the namespace if the service fails";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeScript "namespace-${nsName}-failure" ''
          #!${pkgs.bash}/bin/bash
            set -e
            export PATH=${pkgs.iproute}/bin:$PATH
            ip netns delete ${nsName}
        '';
      };
    };
      
  in mkIf cfg.enable {
    systemd.services = lib.mkMerge [
      (mapAttrs' (name: value: nameValuePair "namespace-${name}" (mkIf (value.enable) (build-namespace name value))) cfg.spaces)
      (mapAttrs' (name: value: nameValuePair "namespace-${name}-failure" (mkIf (value.enable) (build-namespace-failure name value))) cfg.spaces)
    ];
  };
}
