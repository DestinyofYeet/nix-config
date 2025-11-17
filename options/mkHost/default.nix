{ nixpkgs }:
let mkHost = import ./mkHost.nix { inherit nixpkgs; };

in mkHost
