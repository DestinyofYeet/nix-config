{ flake, ... }:
{
  services.nginx = {
    upstreams = {
      "authentik" = {
        servers = {
          ${toString flake.nixosConfigurations."teapot".config.services.authentik.settings.listen.http} = {
            fail_timeout = "10m";
          };

          ${toString flake.nixosConfigurations."nix-server".config.services.authentik.settings.listen.http} =
            {
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
        server ${
          toString flake.nixosConfigurations."teapot".config.services.authentik.settings.listen.ldaps
        };
        server ${
          toString flake.nixosConfigurations."nix-server".config.services.authentik.settings.listen.ldaps
        } backup;
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
