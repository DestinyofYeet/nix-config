{ ... }: {
  services.nginx = {
    enable = true;

    defaultListenAddresses = [ "0.0.0.0" ];

    resolver.addresses = [ "[::1]" "127.0.0.1" ];
  };
}
