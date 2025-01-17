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

  mkConfigEntry =
    host: hostname: user: identFile:
    if (builtins.hasAttr "${identFile}" config.age.secrets) then
      ''
        Host ${host}
          Hostname ${hostname}
          User ${user}
          IdentityFile ${config.age.secrets.${identFile}.path}
          AddKeysToAgent yes
      ''
    else
      "";

  config-github = mkConfigEntry "github.com" "github.com" "git" "ssh-key-github";
  config-oth-gitlab =
    mkConfigEntry "gitlab.oth-regensburg.de" "gitlab.oth-regensburg.de" "git"
      "ssh-key-oth-gitlab";
  config-fsim-ori = mkConfigEntry "fsim.ori" "fsim.othr.de" "beo45216" "ssh-key-fsim-ori";
  config-vps-main = mkConfigEntry "uwuwhatsthis.de" "uwuwhatsthis.de" "ole" "ssh-key-vps-main";
  config-nix-server =
    mkConfigEntry "nix-server.infra.wg" "nix-server.infra.wg" "ole"
      "ssh-key-nix-server";
  config-nix-server-root =
    mkConfigEntry "nix-server.infra.wg" "nix-server.infra.wg" "root"
      "ssh-key-nix-server";
  config-fsim-backup = mkConfigEntry "fsim.backup" "wiki.fsim" "ole" "ssh-key-fsim-backup";
  config-fsim-pedro = mkConfigEntry "fsim.pedro" "195.37.211.44" "beo45216" "ssh-key-fsim-pedro";
  config-vps-teapot = mkConfigEntry "teapot" "ole.blue" "ole" "ssh-key-vps-teapot";
  config-vps-teapot-wg = mkConfigEntry "teapot-wg" "10.100.0.1" "ole" "ssh-key-vps-teapot";
  config-gitea = mkConfigEntry "git.ole.blue" "10.100.0.1" "forgejo" "ssh-key-gitea";
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
