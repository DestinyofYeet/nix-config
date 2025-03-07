{ config, osConfig, lib, custom, secretStore, ... }:
let
  per-device-secrets = secretStore.secrets
    + "/non-server/${osConfig.networking.hostName}";

  mkSecrets = names:
    builtins.listToAttrs (map (name: {
      inherit name;
      value = { file = "${per-device-secrets}/${name}.age"; };
    }) (builtins.filter
      (name: builtins.pathExists "${per-device-secrets}/${name}.age") names));

  mkHosts = entryList:
    builtins.concatStringsSep "\n" (lib.filter (x: x != "") (map (host:
      lib.optionalString
      (builtins.hasAttr "${host.ident}" config.age.secrets) ''
        Host ${host.host}
          Hostname ${host.hostname}
          User ${host.user}
          IdentityFile ${config.age.secrets.${host.ident}.path}
          AddKeysToAgent yes
          Port ${toString (host.port or 22)}
      '') entryList));
in {
  age.secrets = mkSecrets [
    "ssh-key-oth-gitlab"
    "ssh-key-github"
    "ssh-key-fsim-ori"
    "ssh-key-vps-main"
    "ssh-key-nix-server"
    "ssh-key-fsim-backup"
    "ssh-key-fsim-pedro"
    "ssh-key-vps-teapot"
    "ssh-key-gitea"
  ];

  home.file = {
    "/home/ole/.ssh/config" = {
      text = mkHosts [
        rec {
          host = "github.com";
          hostname = host;
          user = "git";
          ident = "ssh-key-github";
        }
        rec {
          host = "gitlab.oth-regensburg.de";
          hostname = host;
          user = "git";
          ident = "ssh-key-oth-gitlab";
        }
        {
          host = "bonk";
          hostname = "uwuwhatsthis.de";
          user = "root";
          ident = "ssh-key-vps-main";
        }
        rec {
          host = "nix-server.infra.wg";
          hostname = host;
          user = "ole";
          ident = "ssh-key-nix-server";
        }
        rec {
          host = "nix-server.infra.wg";
          hostname = host;
          user = "root";
          ident = "ssh-key-nix-server";
        }
        {
          host = "fsim.ori";
          hostname = "fsim.othr.de";
          user = "beo45216";
          ident = "ssh-key-fsim-ori";
        }
        {
          host = "nix-server";
          hostname = custom.nebula.yeet.hosts.nix-server.ip;
          user = "ole";
          ident = "ssh-key-nix-server";
        }
        {
          host = "nix-server";
          hostname = custom.nebula.yeet.hosts.nix-server.ip;
          user = "root";
          ident = "ssh-key-nix-server";
        }
        {
          host = "fsim.backup";
          hostname = "wiki.fsim";
          user = "ole";
          ident = "ssh-key-fsim-backup";
        }
        {
          host = "fsim.pedro";
          hostname = "195.37.211.44";
          user = "beo45216";
          ident = "ssh-key-fsim-pedro";
        }
        {
          host = "fsim.pedro-wg";
          hostname = "10.100.0.1";
          user = "beo45216";
          ident = "ssh-key-fsim-pedro";
          port = 2222;
        }
        {
          host = "teapot";
          hostname = "ole.blue";
          user = "ole";
          ident = "ssh-key-vps-teapot";
        }
        {
          host = "teapot-wg";
          hostname = custom.nebula.yeet.hosts.teapot.ip;
          user = "ole";
          ident = "ssh-key-vps-teapot";
        }
        {
          host = "git.ole.blue";
          hostname = custom.nebula.yeet.hosts.teapot.ip;
          user = "forgejo";
          ident = "ssh-key-gitea";
        }
      ];
    };
  };
}
