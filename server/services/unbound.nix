{
  config,
  ...
}:{
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "192.168.0.250" "127.0.0.1" "10.1.1.2" "0.0.0.0" ];
        port = 53;
        access-control =
          [ "192.168.0.250 allow" "127.0.0.1 allow" "10.1.1.2 allow" "0.0.0.0 allow" ];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      forward-zone = [{
        name = ".";
        forward-addr =
          [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
        forward-tls-upstream = true;
      }];
    };
  };

}
