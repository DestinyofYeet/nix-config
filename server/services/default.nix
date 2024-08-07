{ ... }: let {
  ports = {
    wireguard = 51820;
    netdata = 19999;
    conduit = 6167;
    qbit = 8080;
    ssh = 22;
    http = 80;
    https = 443;
    dns = 53;
    surrealdb = apps.surrealdb.port;
    uptime-kuma = apps.uptime-kuma.port;
    innernet = 29139;
  };

  apps = {
    user = "apps";
    group = "apps";

    qbit = {
      dataDir = "/configs";
      enable = true;
    };

    sonarr = {
      dataDir = "/configs/sonarr";
      enable = true;
      openFirewall = true;
    };

    jellyfin = {
      dataDir = "/configs/jellyfin";
      enable = true;
      openFirewall = true;
    };

    surrealdb = {
      port = 8000;
      enable = true;
      host = "0.0.0.0";
      extraFlags = [
        "--auth"
        "--user"
        "--user"
        "root"
        "--pass"
        "${builtins.readFile config.age.secrets.surrealdb_root_pw.path}"
      ];
    };

    vpn-ns = { vpn-config = config.age.secrets.airvpn_config.path; };

    elasticsearch = {
      enable = false;
      port = 9200;
      listenAddress = "0.0.0.0";
    };

    monerod = {
      enable = true;
      dataDir = "/data/monero-node";
      rpc.address = "0.0.0.0";
    };

    uptime-kuma = {
      enable = true;
      port = 3001;
      settings = {
        PORT = builtins.toString apps.uptime-kuma.port;
        HOST = "0.0.0.0";
      };
    };

    add-replay-gain = {
      enable = false;
      workingDir = "/data/programs/add_replay_gain_to_files";
    };
  };

  firewall_ports = with ports; [
    conduit
    ssh
    wireguard
    netdata
    qbit
    http
    https
    dns
    surrealdb
    uptime-kuma
    innernet
  ];

  namespaces = { name = "vpn-ns"; };
in {
  imports = [
    ./add-replay-gain.nix { inherit apps }
  ];
}
