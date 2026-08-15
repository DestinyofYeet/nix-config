{ rlib, config, ... }: {

  nix = rlib.mkMerge [
    # match nix-channels (nix-shell) with nix flake input
    {
      nixPath = [
        "nixpkgs=/etc/channels/nixpkgs"
        "nixos-config=/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    }
    {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "ole"
          "root"
        ];
        substituters = [
          "https://cache.ole.blue?priority=20"
          "https://install.determinate.systems"
          "https://noctalia.cachix.org"
        ];

        trusted-public-keys = [
          "cache.ole.blue:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    }
    (rlib.mkIf config.capabilities.customNixInterpreter.enable {
      settings = {
        eval-cores = 0;
        experimental-features = [ "wasm-builtin" ];
      };
    })
  ];
}
