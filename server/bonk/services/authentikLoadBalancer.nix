{ ... }: {
  services.nginx = {

    upstreams = {

      "authentik" = {
        servers = {
          "teapot.neb.ole.blue:9443" = { };
          "nix-server.neb.ole.blue:9443" = { backup = true; };
        };
      };

      "authentik-ldap" = {
        servers = {
          "teapot.neb.ole.blue" = { };
          "nix-server.neb.ole.blue" = { backup = true; };
        };
      };
    };

    virtualHosts."idp.ole.blue" = {
      forceSSL = true;
      useACMEHost = "idp.ole.blue";

      locations."/" = {
        proxyWebsockets = true;
        recommendedProxySettings = true;
        proxyPass = "https://authentik";
      };

    };

    streamConfig = ''
      upstream authentik_ldap {
        server teapot.neb.ole.blue:6636;
        server nix-server.neb.ole.blue:6636 backup;
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
