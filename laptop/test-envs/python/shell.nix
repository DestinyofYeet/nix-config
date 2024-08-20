{ pkgs ? import <nixpkgs> {} }:
let 
  pythonVersion = pkgs.python312;
  pythonPackages = with pythonVersion.pkgs; [
    bcrypt 
  ];
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    pythonVersion
  ] ++ pythonPackages;
}
