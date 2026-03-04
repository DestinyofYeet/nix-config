{ ... }:
{
  services.nginx = {

    upstreams = {

      "authentik" = {
        servers = {
          "vm-ha-teapot.neb.ole.blue:9000" = {
            fail_timeout = "10m";
          };

          "vm-ha-nix-server.neb.ole.blue:9000" = {
            backup = true;
          };
        };
      };

      "authentik-ldap" = {
        servers = {
          "vm-ha-teapot.neb.ole.blue" = { };
          "vm-ha-nix-server.neb.ole.blue" = {
            backup = true;
          };
        };
      };
    };

    virtualHosts."idp.ole.blue" = {
      forceSSL = true;
      useACMEHost = "idp.ole.blue";

      locations."/" = {
        proxyWebsockets = true;
        recommendedProxySettings = true;
        proxyPass = "http://authentik";
        extraConfig = ''
          proxy_next_upstream error timeout http_500 http_502 http_503 http_504;
          proxy_connect_timeout 10s;
        '';
      };

    };

    streamConfig = ''
      upstream authentik_ldap {
        server vm-ha-teapot.neb.ole.blue:6636;
        server vm-ha-nix-server.neb.ole.blue:6636 backup;
      }

      server {
        listen 636;

        proxy_pass authentik_ldap;
      }
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 636 ];
    allowedUDPPorts = [ 636 ];
  };

}
