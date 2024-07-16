{ config, pkgs, lib, modulesPath, ... }:
let
  ports = {
    wireguard = 51820;
    netdata = 19999;
    conduit = 6167;
    qbit = 8080;
    ssh = 22;
  };

  firewall_ports = [ ports.conduit ports.ssh ports.wireguard ports.netdata ports.qbit];

  namespaces = {
    name = "vpn-ns";
  };
in
{
    # enable openssh server
    services.openssh.enable = true;
    
    networking.firewall = {
    	allowedTCPPorts = firewall_ports;
    	allowedUDPPorts = firewall_ports;
    };

    networking.nat.enable = true;
    networking.nat.externalInterface = "host0";
    networking.nat.internalInterfaces = [ "wg0" ];


    # matrix conduit server, default port 6167
    services.matrix-conduit = {
    		enable = true;
    		settings.global = {
    			address = "0.0.0.0";
    			server_name = "matrix.ole.blue";
    			allow_registration = true;
    			registration_token = builtins.readFile ./secrets/conduit_registration_token.txt;
    			enable_lightning_bolt = false;
    		};	
	};


    services.nginx = {
    		enable = false;
            # recommendedProxySettings = false;
            # recommendedTlsSettings = true;

            virtualHosts."qbit" = {
              listen = [{ port = 8080; addr = "0.0.0.0"; ssl = false; }];
    			locations."/" = {
    				proxyPass = "http://10.1.1.1:8080";
                    proxyWebsockets = true;

                    extraConfig = 
                    "proxy_pass_header Authorization;" +
                    "proxy_set_header X-Real-IP $remote_addr;" +
	                "proxy_set_header Host $host;" +
                	"proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;" +
                    "proxy_set_header X-Forwarded-Proto $scheme;"
                    ;
    			};
    		};
	};

    services.netdata = {
      enable = true;
    };

    # for connecting to my innernet network
    systemd.services.innernet-infra = {
    		description = "innernet client for infra";
    		wantedBy = [ "multi-user.target" ];
    		after = [ "network-online.target" "nss-lookup.target" ];
    		wants = [ "network-online.target" "nss-lookup.target" ];
    		serviceConfig = {
    			Restart = "always";
    			ExecStart = "${pkgs.innernet}/bin/innernet up infra --daemon --interval 60";
		};
      };

    systemd.services.vpn-ns = { 
      description = "Route all traffic in the namespace to the vpn";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "nss-lookup.target" ];
      wants = [ "network-online.target" "nss-lookup.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "true";
        ExecStart = pkgs.writeScript "ns-isolation" ''
          #!${pkgs.bash}/bin/bash
            export PATH=${pkgs.iproute}/bin:${pkgs.wireguard-tools}/bin:${pkgs.nettools}/bin:${pkgs.iptables}/bin:$PATH
            ip netns add ${namespaces.name}
            ip netns exec ${namespaces.name} ip link set dev lo up
            ip link add wg0 type wireguard
            ip link set wg0 netns ${namespaces.name}
            ip -n ${namespaces.name} addr add 10.178.79.23/24 dev wg0
            ip netns exec ${namespaces.name} wg syncconf wg0 <(${pkgs.wireguard-tools}/bin/wg-quick strip /etc/nixos/secrets/airvpn.conf)
            ip -n ${namespaces.name} link set wg0 up
            ip -n ${namespaces.name} route add default dev wg0

            ip link add veth0 type veth peer name veth1
            ip link set veth1 netns ${namespaces.name}
            ip netns exec ${namespaces.name} ifconfig veth1 10.1.1.1/24 up
            ifconfig veth0 10.1.1.2/24 up
            ip netns exec ${namespaces.name} ip link set dev lo up

            # route all traffic from the local port 8080 to the namespace port 8080, so we can access the webinterface
            iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.1.1.1:8080
            iptables -t nat -A POSTROUTING -j MASQUERADE    
        '';

        ExecStop = pkgs.writeScript "ns-isolation-stop" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.iproute2}/bin/ip netns delete ${namespaces.name}
        '';
      };
    };

    systemd.services.qbittorrent-nox =
      let 
        qbit_config_dir = "~/.config/qBittorrent";
        qbit_config = "${qbit_config_dir}/qBittorrent.conf";
      in
        {
      description = "Run Qbittorrent-nox";
      wantedBy = [ "multi-user.target" ];
      after = [ "vpn-ns.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStartPre = pkgs.writeScript "qbittorrent-nox-pre" ''
        #!${pkgs.bash}/bin/bash
          mkdir -p ${qbit_config_dir}
          echo "[Preferences]" > ${qbit_config}
          echo "WebUI\HostHeaderValidation=false" >> ${qbit_config}
        '';
        ExecStart = "${pkgs.iproute2}/bin/ip netns exec ${namespaces.name} ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
      };
    };
}
