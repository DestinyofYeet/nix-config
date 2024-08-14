{ ... }:{
  services.monero = {
    enable = true;
    dataDir = "/data/monero-node";
    # rpc.address = "0.0.0.0";  # use an ssh-tunnel instead
  };
}
