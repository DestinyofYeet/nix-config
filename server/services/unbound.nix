{
  config,
  ...
}:{
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "0.0.0.0" "::0" ];
        port = 53;
        access-control =
          [ "0.0.0.0/0 allow" "::0/0 allow" ];

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
          [ "9.9.9.9" "8.8.8.8" "1.1.1.1" ];
        forward-tls-upstream = true;
      }];
    };
  };

}
