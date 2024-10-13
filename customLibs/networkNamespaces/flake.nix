{
  description = "A nixos flake to create an network namespace with a wireguard config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } : {
    nixosModules.networkNamespaces = import ./module.nix self;
  };
}
