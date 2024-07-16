{ config, pkgs, lib, modulesPath, ... }:
let
  ports = {
    wireguard = 51820;
    netdata = 19999;
    conduit = 6167;
    ssh = 22;
  };

  firewall_ports = [ ports.conduit ports.ssh ports.wireguard ports.netdata];

  namespaces = {
    name = "vpn-ns";
  };
in
{
    # enable openssh server
    services.openssh.enable = true;
    
    networking.firewall = {
    	# conduit: 6167
    	# ssh: 22 (just to be sure)
        # innernet / wireguard: 51820
        # netdata: 19999
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
    			registration_token = "VX3deHVAEU49CkAWLj3cPfk3BrMgBsGNnWAPV3kV";
    			enable_lightning_bolt = false;
    		};	
	};


    services.nginx = {
    		enable = false;
    		recommendedProxySettings = true;
    		recommendedTlsSettings = true;
    		
    		virtualHosts."matrix.ole.blue" = {
    			locations."/" = {
    				proxyPass = "http://127.0.0.1:123";
    				proxyWebsockets = true;
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
          #! ${pkgs.bash}/bin/bash
            export PATH=${pkgs.iproute}/bin:${pkgs.wireguard-tools}/bin:$PATH
            ${pkgs.iproute2}/bin/ip netns add ${namespaces.name}
            ${pkgs.iproute2}/bin/ip netns exec ${namespaces.name} ip link set dev lo up
            ${pkgs.iproute2}/bin/ip link add wg0 type wireguard
            ${pkgs.iproute2}/bin/ip link set wg0 netns ${namespaces.name}
            ${pkgs.iproute2}/bin/ip -n ${namespaces.name} addr add 10.178.79.23/24 dev wg0
            ${pkgs.iproute2}/bin/ip netns exec ${namespaces.name} wg syncconf wg0 <(${pkgs.wireguard-tools}/bin/wg-quick strip /etc/nixos/secrets/airvpn.conf)
            ${pkgs.iproute2}/bin/ip -n ${namespaces.name} link set wg0 up
            ${pkgs.iproute2}/bin/ip -n ${namespaces.name} route add default dev wg0
        '';

        ExecStop = ''
          #! ${pkgs.bash}/bin/bash
          ${pkgs.iproute2}/bin/ip netns delete ${namespaces.name}
        '';
      };
    };
}
