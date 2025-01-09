{
  ...
}:{
  server = rec {
    host = "ole.blue";
    port = 53;
    publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";

    ip = "10.100.0.0/24";

    mtu = 1000;

    peer = {
      inherit publicKey;

      allowedIPs = [ ip ];

      endpoint = "${host}:${toString port}";

      persistentKeepalive = 25;
    };
  };

  peers = [
    {
      # wattson
      publicKey = "k6JnjO2BpghnwIgmDdARgi06LIHlPyQhoco6kjk6MT8=";
      allowedIPs = [ "10.100.0.2/32" ];
    }
    {
      # main
      publicKey = "CU76SCOQ1hmapZG2TWMhh/cgfjNviYUZcdbUEplW3n0=";
      allowedIPs = [ "10.100.0.3/32" ];
    }
    {
      # nix-server
      publicKey = "6o6D4EVq3qvyu2r90tp+dtstwtXID8QRnd8oyKYKtxc=";
      allowedIPs = [ "10.100.0.4/32" ];
    }
  ];
}
