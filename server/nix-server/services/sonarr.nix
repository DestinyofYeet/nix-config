{ stable-pkgs, config, lib, ... }: {

  # needed for sonarr
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  services.sonarr = {
    enable = true;
    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.configs
      }/sonarr";

    # package = stable-pkgs.sonarr;

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx = let
    default-config = {
      locations = {
        "/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
          extraConfig = ''
            ## Send a subrequest to Authelia to verify if the user is authenticated and has permission to access the resource.
            auth_request /internal/authelia/authz;

            ## Save the upstream metadata response headers from Authelia to variables.
            auth_request_set $user $upstream_http_remote_user;
            auth_request_set $groups $upstream_http_remote_groups;
            auth_request_set $name $upstream_http_remote_name;
            auth_request_set $email $upstream_http_remote_email;

            set $target_url $scheme://$http_host$request_uri;
            error_page 401 =302 https://auth.ole.blue/?rd=$target_url;

            ## Inject the metadata response headers from the variables into the request made to the backend.
            proxy_set_header Remote-User $user;
            proxy_set_header Remote-Groups $groups;
            proxy_set_header Remote-Email $email;
            proxy_set_header Remote-Name $name;

            # Headers for WebSocket support
            proxy_set_header   Host $host;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host $host;
            proxy_set_header   X-Forwarded-Proto $scheme;
            proxy_set_header   Upgrade $http_upgrade;
            proxy_set_header   Connection $http_connection;

            proxy_redirect     off;

            # needed, otherwise results won't load
            send_timeout 100m;
            proxy_connect_timeout 1800;
            proxy_send_timeout 1800;
            proxy_read_timeout 100m;
          '';
        };

        "/internal/authelia/authz" = {
          proxyPass = "https://auth.ole.blue/api/authz/auth-request";
          extraConfig = ''
            internal;
            proxy_pass_request_body off;
            proxy_set_header X-Original-Method $request_method;
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Content-Length "";
            proxy_set_header Connection "";
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; # Timeout if the real server is dead
            proxy_redirect http:// $scheme://;
            proxy_http_version 1.1;
            proxy_cache_bypass $cookie_session;
            proxy_no_cache $cookie_session;
            proxy_buffers 4 32k;
            client_body_buffer_size 128k;

            ## Advanced Proxy Configuration
            send_timeout 5m;
            proxy_read_timeout 240;
            proxy_send_timeout 240;
            proxy_connect_timeout 240;
          '';
        };
      };
    };
  in {

    virtualHosts = {
      "sonarr.local.ole.blue" =
        lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
        // default-config;
    };
  };
}
