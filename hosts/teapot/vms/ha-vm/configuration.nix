{ secretStore, config, ... }:

{
  microvm = {
    vcpu = 4;
    mem = 8096;

    # /var/lib/microvms/<vm>
    shares = [
      {
        proto = "virtiofs";
        tag = "root";
        source = "root";

        mountPoint = "/";
      }
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];

    volumes = [
      {
        image = "rw-nix-store.img";
        mountPoint = config.microvm.writableStoreOverlay;
        size = 5120;
      }
    ];

    writableStoreOverlay = "/nix/.rw-store";
  };

  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };

    hostKeys = [
      {
        path = "/persistent/hostkey-ed25519";
        type = "ed25519";
      }
      {
        path = "/persistent/hostkey-rsa";
        type = "rsa";
      }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ secretStore.keys.hosts.teapot.users.root.key ];

  age.identityPaths = [ "/persistent/hostkey" ];
}
