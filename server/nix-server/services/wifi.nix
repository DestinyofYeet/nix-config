{
  ...
}:
{
  services.create_ap = {
    enable = false;
    # performance sucks with this adpater ~500KB/s max
    settings = {
      CHANNEL = "40";
      INTERNET_IFACE = "enp37s0";
      PASSPHRASE = "12345678";
      SSID = "Nix Wifi";
      WIFI_IFACE = "wlp3s0f0u7";
      GATEWAY = "192.168.12.1";
      WPA_VERSION = "2";
      ETC_HOSTS = "0";
      DHCP_DNS = "gateway";
      NO_DNS = "0";
      NO_DNSMASQ = "0";
      HIDDEN = "0";
      MAC_FILTER = "0";
      MAC_FILTER_ACCEPT = "/etc/hostapd/hostapd.accept";
      ISOLATE_CLIENTS = "0";
      SHARE_METHOD = "nat";
      IEEE80211N = "1";
      IEEE80211AC = "1";
      IEEE80211AX = "1";
      HT_CAPAB = "[HT40+][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC12][NO-HT40-DSSS/CCK]";
      DRIVER = "nl80211";
      FREQ_BAND = "5";
      COUNTRY = "GERMANY";
      DAEMONIZE = "0";
      NO_HAVEGED = "0";
      USE_PSK = "0";
      NO_VIRT = "1";
    };
  };
}
