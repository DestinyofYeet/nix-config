{ config, pkgs, lib, modulesPath, ... }:

{
    # enable openssh server
    services.openssh.enable = true;
    
    networking.firewall = {
    	# conduit: 6167
    	# ssh: 22 (just to be sure)
    	# innernet: 51820
    	allowedTCPPorts = [ 6167 22 51820 ];
    	allowedUDPPorts = [ 6167 22 51820 ];
    };


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

}
