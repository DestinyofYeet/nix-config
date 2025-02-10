{config, ...}: {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.ole.blue";
      listen-http = ":2586";
      cache-file = "/var/cache/ntfy/cache.db";
      attachment-cache-dir = "/var/cache/ntfy/attachments";
      auth-default-access = "deny-all";
      behind-proxy = true;
    };
  };

  services.nginx.virtualHosts."ntfy.ole.blue" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost${config.services.ntfy-sh.settings.listen-http}";
      proxyWebsockets = true;
      extraConfig = ''
        ssl_session_timeout 1d;
        ssl_session_cache shared:MozSSL:10m; # about 40000 sessions
        ssl_session_tickets off;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;

        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_connect_timeout 3m;
        proxy_send_timeout 3m;
        proxy_read_timeout 3m;

        proxy_http_version 1.1;

        client_max_body_size 0;
      '';
    };
  };
}
