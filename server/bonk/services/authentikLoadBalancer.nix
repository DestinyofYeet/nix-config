{ ... }: {
  services.nginx = {

    upstreams."authentik" = {
      servers = {
        "nix-server.neb.ole.blue:9443" = { };
        "teapot.neb.ole.blue:9443" = { };
      };
      extraConfig = ''
        ip_hash;
      '';
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
  };

}
