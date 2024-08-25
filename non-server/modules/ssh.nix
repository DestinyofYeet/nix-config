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
  config-fsim-ori = mkConfigEntry "fsim-ori" "fsim.othr.de" "beo45216" "ssh-fsim-ori";
  config-vps-main = mkConfigEntry "uwuwhatsthis.de" "uwuwhatsthis.de" "ole" "ssh-vps-main";
in {
  services.ssh-agent.enable = true;

  programs.ssh.addKeysToAgent = "yes";

  age.secrets = mkSecrets [
    "ssh-key-oth-gitlab"
    "ssh-key-github"
    "ssh-fsim-ori"
    "ssh-vps-main"
  ];

  #age.secrets = {
  #    ssh-gitlab-oth = {
  #      file = builtins.toPath "${per-device-secrets}/ssh-key-oth-gitlab.age";
  #    };
  #    ssh-vps-main = {
  #      file = builtins.toPath "${per-device-secrets}/ssh-key-vps-main.age";
  #    };

  #    ssh-fsim-ori = {
  #      file = builtins.toPath "${per-device-secrets}/ssh-key-fsim-ori.age";
  #    };

  #    ssh-github = {
  #      file = builtins.toPath "${per-device-secrets}/ssh-key-github.age";
  #    };
  #};


  home.file = {
    "/home/ole/.ssh/config" = {
      text = ''
        Host nix-server
          Hostname 192.168.0.248
          User ole

        ${config-github}
        ${config-oth-gitlab}
        ${config-fsim-ori}
        ${config-vps-main}
      '';
    };
  };
}
