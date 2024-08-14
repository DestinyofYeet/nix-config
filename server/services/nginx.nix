{ ... }:{
  services.nginx = {
    enable = false;
    # recommendedProxySettings = false;
    # recommendedTlsSettings = true;

    virtualHosts."qbit" = {
      listen = [{
        port = 8080;
        addr = "0.0.0.0";
        ssl = false;
      }];
      locations."/" = {
        proxyPass = "http://10.1.1.1:8080";
        proxyWebsockets = true;

        extraConfig = "proxy_pass_header Authorization;"
          + "proxy_set_header X-Real-IP $remote_addr;"
          + "proxy_set_header Host $host;"
          + "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
          + "proxy_set_header X-Forwarded-Proto $scheme;";
      };
    };
  };
}
