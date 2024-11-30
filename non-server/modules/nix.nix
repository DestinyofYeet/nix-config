{ pkgs, config, lib, ... }:
let
  scripts = import ./scripts.nix { inherit config pkgs;};
in {
  age.secrets = {
    nix-file-config = {
      file = ../secrets/nix-config-file.age;
    };
  };


  # home.file.".config/nix/nix.conf" = {
  #   source = config.age.secrets.nix-file-config.path;
  # };

  home.activation.nix-config = ''
    ${scripts.update-needed-content-file}/bin/update-needed-content-file ${config.age.secrets.nix-file-config.path} $HOME/.config/nix/nix.conf
  '';

}
