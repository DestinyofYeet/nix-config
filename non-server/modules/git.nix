{ pkgs, config, ... }:
let
  public-signing-key-path = ../secrets/ssh-key-github-signing-public;

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
      user.signingKey = config.age.secrets.ssh-key-github-signing.path;
    };
  };

  programs.lazygit = {
    enable = true;
  };
}
