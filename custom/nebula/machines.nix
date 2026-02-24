let
  getPrivKey = name: ./${name}/${name}.key.age;
  getPublicKey = name: ./${name}/${name}.crt;

  ipPrefix = "172.27.255";

  mkEntry = name: settings: {
    "${name}" = {
      inherit (settings) ip groups;

      lighthouse = settings.lighthouse or false;
      relay = settings.relay or false;
      external_ips = settings.external_ips or [ ];

      mtu = settings.mtu or 1300;
      use_relays = settings.use_relays or [ ];

      privKeyFile = getPrivKey name;
      publicKeyFile = getPublicKey name;
    };
  };
in
(mkEntry "teapot" {
  ip = "172.27.255.1";
  external_ips = [ "ole.blue:4242" ];
  lighthouse = true;
  relay = true;
  groups = [
    "ligthouse"
    "server"
  ];
})
// (mkEntry "nix-server" {

  ip = "172.27.255.2";
  groups = [ "server" ];
})
// (mkEntry "wattson" {

  ip = "172.27.255.3";
  groups = [
    "end-user"
    "laptop"
  ];
})
// (mkEntry "main" {

  ip = "172.27.255.4";
  groups = [
    "end-user"
    "desktop"
  ];
})
// (mkEntry "kartoffelkiste" {

  ip = "172.27.255.6";
  groups = [
    "end-user"
    "laptop"
  ];
})
// (mkEntry "bonk" {

  ip = "172.27.255.7";
  external_ips = [ "uwuwhatsthis.de:4242" ];
  lighthouse = true;
  groups = [
    "lighthouse"
    "server"
  ];
})
// (mkEntry "nixie" {

  ip = "172.27.255.8";
  groups = [ "server" ];
})
// (mkEntry "teapot-ha-vm" {
  ip = "${ipPrefix}.9";
  groups = [ "server" ];
  use_relays = [ "${ipPrefix}.1" ];
})
// (
  mkEntry "bonk-ha-vm" {
    ip = "${ipPrefix}.10";
    groups = [ "server" ];
    use_relays = [ "${ipPrefix}.1" ];

  }
  // (mkEntry "nix-server-ha-vm" {
    ip = "${ipPrefix}.11";
    groups = [ "server" ];
    use_relays = [ "${ipPrefix}.1" ];
  })
)
