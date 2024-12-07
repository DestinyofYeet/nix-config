{
  lib,
  ...
}:{
  networking = {
    hostName = "teapot";

    # firewall.enable = false;

    useDHCP = false;

    interfaces.enp6s18 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "5.83.152.153";
          prefixLength = 26;
        }
      ];
    };

    defaultGateway = {
      address = "5.83.152.129";
      interface = "enp6s18";
    };

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
