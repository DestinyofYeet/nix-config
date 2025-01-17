{
  config,
  osConfig,
  lib,
  ...
}:

let
  per-device-secrets = ../secrets/${osConfig.networking.hostName};

  mkSecrets =
    names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = {
          file = "${per-device-secrets}/${name}.age";
        };
      }) (builtins.filter (name: builtins.pathExists "${per-device-secrets}/${name}.age") names)
    );

  mkConfigEntry = settings:
    if (builtins.hasAttr "${settings.ident}" config.age.secrets) then
      ''
        Host ${settings.host}
          Hostname ${settings.hostname}
          User ${settings.user}
          IdentityFile ${config.age.secrets.${settings.ident}.path}
          AddKeysToAgent yes
          Port ${settings.port or 22}
      ''
    else
      "";

  config-github = mkConfigEntry rec { host = "github.com"; hostname = host; user = "git"; ident = "ssh-key-github"; };
  config-oth-gitlab = rec {
    host = "gitlab.oth-regensburg.de";
    hostname = host;
    user = "git";
    ident = "ssh-key-oth-gitlab";
  };
  config-fsim-ori = mkConfigEntry {
    host = "fsim.ori";
    hostname = "fsim.othr.de";
    user = "beo45216";
    ident = "ssh-key-fsim-ori";
  };
  config-vps-main = mkConfigEntry rec { host = "uwuwhatsthis.de"; hostname = host; user = "ole"; ident = "ssh-key-vps-main"; };
  config-nix-server = rec {
    host = "nix-server.infra.wg";
    hostname = host;
    user = "ole";
    ident = "ssh-key-nix-server";
  };
  config-nix-server-root = rec {
    host = "nix-server.infra.wg";
    hostname = host;
    user = "root";
    ident = "ssh-key-nix-server";
  };
  config-fsim-backup = mkConfigEntry { host = "fsim.backup"; hostname = "wiki.fsim"; user = "ole"; ident = "ssh-key-fsim-backup";};
  config-fsim-pedro = mkConfigEntry { host = "fsim.pedro"; hostname = "195.37.211.44"; user = "beo45216"; ident = "ssh-key-fsim-pedro";};
  config.fsim-pedro-jump = mkConfigEntry { host = "fsim.pedro-wg"; hostname = "10.100.0.1"; user = "beo45216"; ident = "ssh-key-fsim-pedro"; port = 2222; };
  config-vps-teapot = mkConfigEntry { host = "teapot"; hostname = "ole.blue"; user = "ole"; ident = "ssh-key-vps-teapot"; };
  config-vps-teapot-wg = mkConfigEntry { host = "teapot-wg"; hostname = "10.100.0.1"; user = "ole"; ident = "ssh-key-vps-teapot"; };
  config-gitea = mkConfigEntry { host = "git.ole.blue"; hostname = "10.100.0.1"; user = "forgejo"; ident = "ssh-key-gitea"; };
in
{
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
      text = ''
        ${config-github}
        ${config-oth-gitlab}
        ${config-vps-main}
        ${config-nix-server}
        ${config-nix-server-root}
        ${config-fsim-ori}
        ${config-fsim-backup}
        ${config-fsim-pedro}
        ${config-vps-teapot}
        ${config-vps-teapot-wg}
        ${config-gitea}
      '';
    };
  };
}
