{
  lib,
  config,
  pkgs,
  ...
}:{
  networking.wlanInterfaces = {
    "wlan-station0" = { device = "wlp3s0f0u7"; };
    "wlan-ap0" = { device = "wlp3s0f0u7"; mac = "ca:00:df:e9:13:5f"; };
  };

  networking.networkmanager.unmanaged = [ "interface:wlp*" "interface:wlan-ap0" ];

  services.hostapd = {
    enable = true;
    radios = {
      "wlan-ap0" = {
        wifi5.enable = true;
        # wifi4.enable = true;
        wifi4.capabilities = [];
        networks = {
          "wlan-ap0" = {
            ssid = "wlan-ap0-nix-wlan";
            authentication.saePasswords = [
              {
                password = "1234578";
              }
            ];
          };
        };      
      };
    };
  };

  networking.interfaces."wlan-ap0".ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.12.1"; prefixLength = 24; }];

  services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
    enable = true;
    settings = {
      dhcp-range = [ "192.168.12.10,192.168.12.254,24h"];
      bind-interfaces = true;
      interfaces = "wlan-ap0";
    };
  };

  networking.firewall.allowedUDPPorts = lib.optionals config.services.hostapd.enable [53 67]; # DNS & DHCP

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; # Enable package forwarding.

  systemd.services.wifi-relay = let inherit (pkgs) iptables;
    in {
      description = "iptables rules for wifi-relay";
      after = [ "dnsmasq.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${iptables}/bin/iptables -w -t nat -I POSTROUTING -s 192.168.12.0/24 ! -o wlan-ap0 -j MASQUERADE
        ${iptables}/bin/iptables -w -I FORWARD -i wlan-ap0 -s 192.168.12.0/24 -j ACCEPT
        ${iptables}/bin/iptables -w -I FORWARD -i wlan-station0 -d 192.168.12.0/24 -j ACCEPT
      '';
    };
}
