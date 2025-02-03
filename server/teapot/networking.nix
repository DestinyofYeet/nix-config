{lib, ...}: let
  interface = "ens18";
in {
  networking = {
    hostName = "teapot";

    # firewall.enable = false;

    useDHCP = false;

    interfaces.${interface} = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "5.83.152.153";
          prefixLength = 26;
        }
      ];

      # ipv6.addresses = [
      #   {
      #     address = "2a06:de00:403:9d7c::";
      #     prefixLength = 64;
      #   }
      # ];
    };

    defaultGateway = {
      address = "5.83.152.129";
      interface = interface;
    };

    # defaultGateway6 = {
    #   address = "2a06:de00:403:9d7c::1";
    #   interface = "enp6s18";
    # };

    nameservers = lib.mkForce [
      "1.1.1.1"
      "8.8.8.8"
    ];

    enableIPv6 = false;
  };

  boot.kernel.sysctl = {
    # Allow containers to access internet
    "net.ipv4.ip_forward" = 1;
  };
}
