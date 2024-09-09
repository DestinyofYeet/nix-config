{ config, ... }:{
  services.monero = {
    enable = true;
    dataDir = "${config.serviceSettings.paths.data}/monero-node";
    # rpc.address = "0.0.0.0";  # use an ssh-tunnel instead
  };
}
