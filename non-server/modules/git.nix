{ pkgs, config, lib, osConfig, secretStore, ... }:
let
  public-signing-key-path = secretStore.secrets
    + "/non-server/${osConfig.networking.hostName}/ssh-key-signing-key";

  allowed-signers = pkgs.writeText "allowed_signers" ''
    * ${builtins.readFile public-signing-key-path}
  '';

  git-config-other = (pkgs.formats.toml { }).generate "git-config-other" {
    user = {
      name = "DestinyofYeet";
      email = "ole@ole.blue";
    };
  };

  git-config-oth = (pkgs.formats.toml { }).generate "git-config-oth" {
    user = {
      name = "beo45216";
      email = "ole.bendixen@st.oth-regensburg.de";
    };
  };
in {
  # name and email is set in baseline
  programs.git = {
    includes = [
      {
        path = git-config-oth;
        condition = "gitdir/i:~/github/oth/";
      }
      {
        path = git-config-other;
        condition = "gitdir/i:~/github/rest/";
      }
    ];
    extraConfig = lib.mkMerge [
      {
        safe = { directory = "*"; };
        init = { defaultBranch = "main"; };
      }
      (lib.mkIf (builtins.hasAttr "ssh-key-gitea" config.age.secrets) {
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = builtins.toString allowed-signers;
        };

        commit.gpgsign = true;
        user.signingKey = config.age.secrets.ssh-key-gitea.path;
      })
    ];
  };

  programs.lazygit = { enable = true; };
}
