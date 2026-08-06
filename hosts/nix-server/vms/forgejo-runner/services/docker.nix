{ ... }: {
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        storage-driver = "vfs";
      };
    };

    oci-containers = {
      backend = "docker";
    };
  };
}
