{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs } : 
  let 
    pkgs = import nixpkgs { system = "x86_64-linux"; };

    python = pkgs.python3;

    pythonPkgs = with python.pkgs; [
      
    ];
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = [
        python
      ] ++ pythonPkgs;
    };
  };
}
