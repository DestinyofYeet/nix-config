{
  pkgs,
  config,
  lib,
  osConfig,
  secretStore,
  ...
}: let
  public-signing-key-path = secretStore.secrets + "/non-server/${osConfig.networking.hostName}/ssh-key-signing-key";

  allowed-signers = pkgs.writeText "allowed_signers" ''
    * ${builtins.readFile public-signing-key-path}
  '';
in {
  # name and email is set in baseline
  programs.git = {
    extraConfig =
      {
        safe = {
          directory = "*";
        };
      }
      // lib.mkIf (builtins.hasAttr "ssh-key-gitea" config.age.secrets) {
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = builtins.toString allowed-signers;
        };

        commit.gpgsign = true;
        user.signingKey = config.age.secrets.ssh-key-gitea.path;
      };
  };

  programs.lazygit = {
    enable = true;
  };
}
