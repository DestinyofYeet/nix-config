{ config, secretStore, ... }:
{

  microvm = {
    vcpu = 4;
    mem = 4096;

    shares = [
      {
        proto = "virtiofs";
        tag = "root";
        source = "root";
        mountPoint = "/";
      }
    ];

    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = config.microvm.writableStoreOverlay;
        size = 20480;
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
        path = "/persistent/hostkey";
        type = "ed25519";
      }
      {
        path = "/persistent/hostkey-rsa";
        type = "rsa";
      }
    ];
  };

  # users.users.root.initialPassword = "changeme";

  users.users.root.openssh.authorizedKeys.keys = [ secretStore.keys.hosts.nix-server.users.root.key ];

  age.identityPaths = [ "/persistent/hostkey" ];
}
