{ flake, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

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

      locations =
        let
          extraConfig = ''
            proxy_next_upstream error timeout http_500 http_502 http_503 http_504;
            proxy_connect_timeout 10s;
          '';
          proxyPass = "http://authentik";
        in
        {

          "/" = {
            inherit proxyPass extraConfig;
          };

          "/ws/" = {
            proxyWebsockets = true;
            inherit extraConfig proxyPass;
          };

          "/static/" = {
            inherit proxyPass;
            extraConfig = ''
              ${extraConfig}
              add_header Cache-Control "public, max-age=0, must-revalidate";
              add_header Expires "Thu, 01 Jan 1970 00:00:00 GMT";
            '';
          };

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
