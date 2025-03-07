{ lib, ... }:
let interface = "enp6s18";
in {
  networking = {
    hostName = "bonk";
    useDHCP = false;

    interfaces.${interface} = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "45.137.68.119";
        prefixLength = 25;
      }];

      # ipv6.addresses = [
      #   {
      #     address = "2a06:de00:403:9d7c::";
      #     prefixLength = 64;
      #   }
      # ];
    };

    defaultGateway = {
      address = "45.137.68.1";
      interface = interface;
    };

    # defaultGateway6 = {
    #   address = "2a06:de00:403:9d7c::1";
    #   interface = "enp6s18";
    # };

    nameservers = lib.mkForce [ "1.1.1.1" "8.8.8.8" ];

    enableIPv6 = false;
  };
}
