{ config, pkgs, lib, modulesPath, ... }:
let
  ports = {
    wireguard = 51820;
    netdata = 19999;
    conduit = 6167;
    qbit = 8080;
    ssh = 22;
    http = 80;
    https = 443;
    dns = 53;
    surrealdb = apps.surrealdb.port;
  };

  apps = {
    user = "apps";
    group = "apps";

    qbit = {
      dirs.config = "/configs/";
      enable = true;      
    };
    
    sonarr = {
      dirs.config = "/configs/sonarr";
      enable = true;
    };

    jellyfin = {
      dirs.config = "/configs/jellyfin";
      enable = true;
    };

    surrealdb = {
      port = 8000;
      enable = true;
      host = "0.0.0.0";
      pw = builtins.readFile ./secrets/surrealdb_root_pw.txt;
      extraFlags = [
        "--auth"
        "--user"
        "--user"
        "root"
        "--pass"
        "${builtins.readFile ./secrets/surrealdb_root_pw.txt}"
      ];
    };

    vpn-ns = {
      vpn-config = "/etc/nixos/secrets/airvpn.conf";
    };
  };

  firewall_ports = with ports; [ conduit ssh wireguard netdata qbit http https dns surrealdb ];

  namespaces = {
    name = "vpn-ns";
  };
in {

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
           "surrealdb"
         ];
    

    # enable openssh server
    services.openssh.enable = true;
    
    networking.firewall = {
    	allowedTCPPorts = firewall_ports;
    	allowedUDPPorts = firewall_ports;
    };




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

      upholds = [ "qbittorrent-nox.service" ];

      onFailure = [ "vpn-ns-failure.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "true";
        ConditionPathExists= "!/var/run/netns/${namespaces.name}";
        ExecStart = pkgs.writeScript "ns-isolation" ''
          #!${pkgs.bash}/bin/bash
            set -e
            export PATH=${pkgs.iproute}/bin:${pkgs.wireguard-tools}/bin:${pkgs.nettools}/bin:${pkgs.iptables}/bin:$PATH
            ip netns add ${namespaces.name}
            ip netns exec ${namespaces.name} ip link set dev lo up
            ip link add wg0 type wireguard
            ip link set wg0 netns ${namespaces.name}
            ip -n ${namespaces.name} addr add $(${pkgs.coreutils}/bin/cat ${apps.vpn-ns.vpn-config} | ${pkgs.gnugrep}/bin/grep Address | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.gnused}/bin/sed 's/,.*$//')/24 dev wg0
            ip netns exec ${namespaces.name} wg syncconf wg0 <(${pkgs.wireguard-tools}/bin/wg-quick strip ${apps.vpn-ns.vpn-config})
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
          set -e
          export PATH=${pkgs.iproute}/bin:${pkgs.iptables}/bin:$PATH
          ip netns delete ${namespaces.name}
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
        ExecStart = pkgs.writeScript "vpn-ns-failure" ''
          #!${pkgs.bash}/bin/bash
            set -e
            export PATH=${pkgs.iproute}/bin:$PATH
            ip netns delete ${namespaces.name}
          '';
      };
    };

    systemd.services.qbittorrent-nox = {
      description = "Run Qbittorrent-nox";
      wantedBy = [ "multi-user.target" ];
      requires = [ "vpn-ns.service" ];
      after = [ "vpn-ns.service" ];

      partOf = [ "vpn-ns.service" ];

      enable = apps.qbit.enable;
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.iproute2}/bin/ip netns exec ${namespaces.name} /run/wrappers/bin/sudo -u ${apps.user}  ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${apps.qbit.dirs.config}";
      };
    };

  services.jellyfin = {
    enable = apps.jellyfin.enable;
    dataDir = apps.jellyfin.dirs.config;
    user = 	apps.user;
    group = apps.group;
    openFirewall = true;
  };

  services.sonarr = {
    enable = apps.sonarr.enable;
    dataDir = apps.sonarr.dirs.config;
    user = apps.user;
    group = apps.group;
    openFirewall = true;
  };

  services.surrealdb = {
    inherit (apps.surrealdb) enable host extraFlags port;
  };
}
