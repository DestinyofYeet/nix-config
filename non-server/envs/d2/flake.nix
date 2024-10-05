{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } : 
  let 
    pkgs = import nixpkgs { system = "x86_64-linux"; };

  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        d2
      ];

      shellHook = ''
         d2 -w layout.d2 out.svg
      ''; 
    };
  };
}
