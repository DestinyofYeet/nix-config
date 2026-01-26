{ pkgs, inputs, lib }: {
  getMkVm = mkVmSettings: name: vmSettings: {
    ${name} = {

      pkgs = vmSettings.pkgs or pkgs;
      specialArgs = mkVmSettings.flake.defaultSpecialArgs // { vmName = name; };
      config = lib.mkMerge [
        {
          microvm = {
            interfaces = [{
              type = "tap";
              id = "vm-${name}";
              mac = vmSettings.mac;
            }];
          };

          system.stateVersion = mkVmSettings.config.system.stateVersion;

          networking.useNetworkd = false;
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Name = "enp*";
              networkConfig = {
                Address = [ "${vmSettings.ip}/24" ];
                Gateway = mkVmSettings.gateway;
                DNS = mkVmSettings.dns;
                IPv6AcceptRA = true;
                DHCP = "no";
              };
            };
          };
          networking.useDHCP = lib.mkForce false;
        }

        vmSettings.config
      ];
    };
  };
}
