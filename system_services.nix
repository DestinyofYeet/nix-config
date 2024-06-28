{ config, pkgs, lib, modulesPath, ... }:

{
#systemd.services.innernet-mynet = {
#    description = "innernet server for infra";
#    wantedBy = [ "multi-user.target" ];
#    after = [ "network-online.target" "nss-lookup.target" ];
#    wants = [ "network-online.target" "nss-lookup.target" ];
#    path = with pkgs; [ iproute ];
#    environment = { RUST_LOG = "info"; };
#    serviceConfig = {
#      Restart = "always";
#      ExecStart = "${innernet}/bin/innernet up infra --daemon --interval 60";
#    };
#  };


# enable openssh server
services.openssh.enable = true;

# matrix conduit server, default port 6167
services.matrix-conduit = {
		enable = false;

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
}
