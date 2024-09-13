{ config, lib, ... }:
{
  age.secrets = {
    nix-file-config = {
      file = ../secrets/nix-config-file.age;
    };
  };

  home.activation.nix-config = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run rm $HOME/.config/nix/nix.conf && ln -s ${config.age.secrets.nix-file-config.path} $HOME/.config/nix/nix.conf
  '';

}
