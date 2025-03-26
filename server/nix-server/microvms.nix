{ flake, pkgs, inputs, config, ... }: {
  microvm = {
    host.enable = true;
    vms = {
      "roflroflrofl" = {
        inherit pkgs;
        config = {
          system.stateVersion = config.system.stateVersion;
          microvm.shares = [{
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
          }];
        };
      };
    };
  };
}
