let
  getPrivKey = name: ./${name}/${name}.key.age;
  getPublicKey = name: ./${name}/${name}.crt;

  mkEntry = name: settings: {
    "${name}" = {
      inherit (settings) ip groups;

      privKeyFile = getPrivKey name;
      publicKeyFile = getPublicKey name;
    };
  };
in {
  "teapot" = {
    ip = "172.27.255.1";
    external_ips = [ "ole.blue:4242" ];
    lighthouse = true;
    groups = [ "ligthouse" "server" ];

    privKeyFile = ./teapot/teapot.key.age;
    publicKeyFile = ./teapot/teapot.crt;
  };

  "nix-server" = {
    ip = "172.27.255.2";
    groups = [ "server" ];
    privKeyFile = ./nix-server/nix-server.key.age;
    publicKeyFile = ./nix-server/nix-server.crt;
  };

  "wattson" = {
    ip = "172.27.255.3";
    groups = [ "end-user" "laptop" ];

    privKeyFile = ./wattson/wattson.key.age;
    publicKeyFile = ./wattson/wattson.crt;
  };

  "main" = {
    ip = "172.27.255.4";
    groups = [ "end-user" "desktop" ];

    privKeyFile = ./main/main.key.age;
    publicKeyFile = ./main/main.crt;
  };

  "kartoffelkiste" = {
    ip = "172.27.255.6";
    groups = [ "end-user" "laptop" ];

    privKeyFile = ./kartoffelkiste/kartoffelkiste.key.age;
    publicKeyFile = ./kartoffelkiste/kartoffelkiste.crt;
  };

  "bonk" = {
    ip = "172.27.255.7";
    external_ips = [ "uwuwhatsthis.de:4242" ];
    lighthouse = true;
    groups = [ "lighthouse" "server" ];

    privKeyFile = getPrivKey "bonk";
    publicKeyFile = getPublicKey "bonk";
  };

  "nixie" = {
    ip = "172.27.255.8";
    groups = [ "end-user" "server" ];

    privKeyFile = getPrivKey "nixie";
    publicKeyFile = getPublicKey "nixie";
  };
} // (mkEntry "teapot-ha-vm" {

  ip = "127.27.255.9";
  groups = [ "end-user" "server" ];
}) // (mkEntry "bonk-ha-vm" {
  ip = "127.27.255.10";
  groups = [ "end-user" "server" ];

})
