{ ... }: {
  authelia = {
    root = ''
      auth_request /internal/authelia/authz;
      auth_request_set $user $upstream_http_remote_user;
      auth_request_set $groups $upstream_http_remote_groups;
      auth_request_set $name $upstream_http_remote_name;
      auth_request_set $email $upstream_http_remote_email;
      set $target_url $scheme://$http_host$request_uri;
      error_page 401 =302 https://auth.ole.blue/?rd=$target_url; 
    '';

    location = {
      "/internal/authelia/authz" = {
        proxyPass = "https://auth.ole.blue/api/authz/auth-request";
        extraConfig =
          "  internal;\n  proxy_pass_request_body off;\n  proxy_set_header X-Original-Method $request_method;\n  proxy_set_header X-Original-URL $scheme://$http_host$request_uri;\n  proxy_set_header X-Forwarded-For $remote_addr;\n  proxy_set_header Content-Length \"\";\n  proxy_set_header Connection \"\";\n  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; # Timeout if the real server is dead\n  proxy_redirect http:// $scheme://;\n  proxy_http_version 1.1;\n  proxy_cache_bypass $cookie_session;\n  proxy_no_cache $cookie_session;\n  proxy_buffers 4 32k;\n  client_body_buffer_size 128k;\n\n  ## Advanced Proxy Configuration\n  send_timeout 5m;\n  proxy_read_timeout 240;\n  proxy_send_timeout 240;\n  proxy_connect_timeout 240;\n";
      };
    };
  };
}
