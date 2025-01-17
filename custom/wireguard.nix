{
  ...
}:
{
  server = rec {
    host = "ole.blue";
    port = 53;
    publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";

    ip = "10.100.0.0/24";

    mtu = 1300;

    peer = {
      inherit publicKey;

      name = "teapot";

      allowedIPs = [ ip ];

      endpoint = "${host}:${toString port}";

      persistentKeepalive = 25;
    };
  };

  peers = [
    {
      # wattson
      name = "wattson";
      publicKey = "Fh7Su7jqjglibebuH/gen31wWwQWZWx+QcLSESVo1FY=";
      allowedIPs = [ "10.100.0.2/32" ];
    }
    {
      # main
      name = "main";
      publicKey = "CU76SCOQ1hmapZG2TWMhh/cgfjNviYUZcdbUEplW3n0=";
      allowedIPs = [ "10.100.0.3/32" ];
    }
    {
      # nix-server
      name = "nix-server";
      publicKey = "6o6D4EVq3qvyu2r90tp+dtstwtXID8QRnd8oyKYKtxc=";
      allowedIPs = [ "10.100.0.4/32" ];
    }
    {
      name = "handy";
      publicKey = "3rQIsDLdxWZf0H4Kf41JNOynpP1WqMSqPSm+BgdN41g=";
      allowedIPs = [ "10.100.0.5/32" ];
    }
  ];
}
