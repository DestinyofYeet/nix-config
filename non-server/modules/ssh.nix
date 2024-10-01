{ config, osConfig, lib, ... }: 

let 
  per-device-secrets = ../secrets/${osConfig.networking.hostName};

  mkSecrets = names : builtins.listToAttrs (map (name: 
    { 
      inherit name; 
      value = { 
        file = "${per-device-secrets}/${name}.age"; 
      }; 
    }) (builtins.filter (name: builtins.pathExists "${per-device-secrets}/${name}.age") names));

  
  mkConfigEntry = host: hostname: user: identFile : if (builtins.hasAttr "${identFile}" config.age.secrets) then ''
    Host ${host}
      Hostname ${hostname}
      User ${user}
      IdentityFile ${config.age.secrets.${identFile}.path}
  '' else "";

  config-github = mkConfigEntry "github.com" "github.com" "git" "ssh-key-github";
  config-oth-gitlab = mkConfigEntry "gitlab.oth-regensburg.de" "gitlab.oth-regensburg.de" "git" "ssh-key-oth-gitlab";
  config-fsim-ori = mkConfigEntry "ori.fsim" "fsim.othr.de" "beo45216" "ssh-key-fsim-ori";
  config-vps-main = mkConfigEntry "uwuwhatsthis.de" "uwuwhatsthis.de" "ole" "ssh-key-vps-main";
  config-nix-server = mkConfigEntry "nix-server.infra.wg" "nix-server.infra.wg" "ole" "ssh-key-nix-server";
  config-nix-server-root = mkConfigEntry "nix-server.infra.wg" "nix-server.infra.wg" "root" "ssh-key-nix-server";
  config-fsim-backup = mkConfigEntry "backup.fsim" "wiki.fsim" "ole" "ssh-key-fsim-backup";
in {
  services.ssh-agent.enable = true;

  programs.ssh.addKeysToAgent = "yes";

  age.secrets = mkSecrets [
    "ssh-key-oth-gitlab"
    "ssh-key-github"
    "ssh-key-fsim-ori"
    "ssh-key-vps-main"
    "ssh-key-nix-server"
    "ssh-key-fsim-backup"
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
      '';
    };
  };
}
