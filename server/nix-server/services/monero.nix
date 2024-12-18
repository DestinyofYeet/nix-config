{
  config,
  lib,
  ...
}:
{
  services.monero = {
    enable = true;
    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.data}/monero-node";
    # rpc.address = "0.0.0.0";  # use an ssh-tunnel instead
  };
}
