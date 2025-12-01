{ secretStore, ... }: {

  imports = [ ./services ];

  microvm = {
    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keys =
    [ secretStore.keys.root.nix-server ];
}
