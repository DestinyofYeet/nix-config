{ config, ... }:{
  config.virtualisation.oci-containers.containers = {
    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [ "127.0.0.1:8191:8191" ];
      extraOptions = [
        "--cgroup-manager=systemd"
      ];
    };
  };
}
