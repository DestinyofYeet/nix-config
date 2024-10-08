{ pkgs, config, ... }:
let
  namespace = "vpn-ns";

  qbit = {
    dataDir = "${config.serviceSettings.paths.configs}";
    enable = true;
  };
in {

  age.secrets = {
    airvpn-config = {
      file = ../secrets/airvpn_config.age;
      path = "/etc/wireguard/wg0.conf";
    };
  };

  systemd.services.vpn-ns = {
    description = "Route all traffic in the namespace to the vpn";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "nss-lookup.target" "unbound.service" ];
    wants = [ "network-online.target" "nss-lookup.target" "unbound.service" ];

    requires = [ "unbound.service" ];

    upholds = [ "qbittorrent-nox.service" ];

    onFailure = [ "vpn-ns-failure.service" ];

    unitConfig = {
      ConditionPathExists = "!/var/run/netns/${namespace}";
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "true";
      ExecStartPre = "${pkgs.bash}/bin/sh -c 'until /run/current-system/sw/bin/host de3.vpn.airdns.org; do sleep 1; done'";
      ExecStart = pkgs.writeScript "ns-isolation" ''
        #!${pkgs.bash}/bin/bash
          set -e
          export PATH=${pkgs.iproute}/bin:${pkgs.wireguard-tools}/bin:${pkgs.nettools}/bin:${pkgs.iptables}/bin:$PATH
          ip netns add ${namespace}
          ip netns exec ${namespace} ip link set dev lo up
          ip link add wg0 type wireguard
          ip link set wg0 netns ${namespace}
          ip -n ${namespace} addr add $(${pkgs.coreutils}/bin/cat ${config.age.secrets.airvpn-config.path} | ${pkgs.gnugrep}/bin/grep Address | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.gnused}/bin/sed 's/,.*$//')/24 dev wg0
          ip netns exec ${namespace} wg syncconf wg0 <(${pkgs.wireguard-tools}/bin/wg-quick strip ${config.age.secrets.airvpn-config.path})
          ip -n ${namespace} link set wg0 up
          ip -n ${namespace} route add default dev wg0

          ip link add veth0 type veth peer name veth1
          ip link set veth1 netns ${namespace}
          ip netns exec ${namespace} ifconfig veth1 10.1.1.1/24 up
          ifconfig veth0 10.1.1.2/24 up
          ip netns exec ${namespace} ip link set dev lo up

          # route all traffic from the local port 8080 to the namespace port 8080, so we can access the webinterface
          iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.1.1.1:8080
          iptables -t nat -A POSTROUTING -j MASQUERADE
      '';

      ExecStop = pkgs.writeScript "ns-isolation-stop" ''
        #!${pkgs.bash}/bin/bash
        set -e
        export PATH=${pkgs.iproute}/bin:${pkgs.iptables}/bin:$PATH
        ip netns delete ${namespace}
        iptables -t nat -D PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.1.1.1:8080
        iptables -t nat -D POSTROUTING -j MASQUERADE
        ip link delete veth0 
      '';
    };
  };

  systemd.services.vpn-ns-failure = {
    description = "Delete the vpn namespace if the service fails";
    serviceConfig = {
      Type = "oneshot";
      # ExecStartPre="/run/current-system/sw/bin/sleep 30";
      ExecStart = pkgs.writeScript "vpn-ns-failure" ''
        #!${pkgs.bash}/bin/bash
          set -e
          export PATH=${pkgs.iproute}/bin:$PATH
          ip netns delete ${namespace}
      '';
    };
  };

  systemd.services.qbittorrent-nox = {
    description = "Run Qbittorrent-nox";
    wantedBy = [ "multi-user.target" ];
    requires = [ "vpn-ns.service" ];
    after = [ "vpn-ns.service" ];

    partOf = [ "vpn-ns.service" ]; # qbit stops if the vpn-namespace service stops

    enable = qbit.enable;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      NetworkNamespacePath="/var/run/netns/${namespace}";
      User = config.serviceSettings.user;
      Group = config.serviceSettings.group;
      ExecStart =
        "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${qbit.dataDir}";

      TimeoutStopSec = 30; # takes the full 90 seconds when trying to stop this service, dunno why
    };
  };

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://10.1.1.1:8080";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # Prevent gzip encoding issues
          proxy_set_header Accept-Encoding "";

          # If necessary, disable buffer to get immediate response from upstream
          proxy_buffering off;
        '';
      };
    };
  in {
    virtualHosts = {
      "qbittorrent.nix-server.infra.wg" = {} // default-config;

      "qbittorrent.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
