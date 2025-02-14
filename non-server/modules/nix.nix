{
  config,
  lib,
  secretStore,
  ...
}: {
  age.secrets = {
    nix-file-config = {
      file = secretStore.secrets + /non-server/nix-config-file.age;
    };
  };

  # home.file.".config/nix/nix.conf" = {
  #   source = config.age.secrets.nix-file-config.path;
  # };

  home.activation.nix-config = ''
    ${lib.custom.update-needed-content-file}/bin/update-needed-content-file ${config.age.secrets.nix-file-config.path} $HOME/.config/nix/nix.conf
  '';
}
