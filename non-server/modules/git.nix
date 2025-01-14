{ pkgs, config, osConfig, ... }:
let
  public-signing-key-path = ../secrets/${osConfig.networking.hostName}/ssh-key-signing-key;

  allowed-signers = pkgs.writeText "allowed_signers" ''
    * ${builtins.readFile public-signing-key-path}
  '';

in
{

  age.secrets = {
    ssh-key-github-signing.file = ../secrets/ssh-key-github-signing.age;
  };

  programs.git = {
    extraConfig = {
      safe = {
        directory = "*";
      };

      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = (builtins.toString allowed-signers);
      };

      commit.gpgsign = true;
      user.signingKey = config.age.secrets.ssh-key-gitea.path;
    };
  };

  programs.lazygit = {
    enable = true;
  };
}
