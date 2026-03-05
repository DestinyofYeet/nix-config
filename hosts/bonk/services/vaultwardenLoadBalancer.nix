{ ... }:
{
  services.nginx = {

    upstreams = {

      "vaultwarden" = {
        servers = {
          "vm-ha-teapot.neb.ole.blue:7462" = {
            fail_timeout = "10m";
          };

          "vm-ha-nix-server.neb.ole.blue:7462" = {
            backup = true;
          };
        };
      };
    };

    virtualHosts."vault.ole.blue" = {
      forceSSL = true;
      useACMEHost = "vault.ole.blue";

      locations."/" = {
        proxyWebsockets = true;
        recommendedProxySettings = true;
        proxyPass = "http://vaultwarden";
        extraConfig = ''
          proxy_next_upstream error timeout http_500 http_502 http_503 http_504;
          proxy_connect_timeout 10s;
        '';
      };

    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 636 ];
    allowedUDPPorts = [ 636 ];
  };

}
