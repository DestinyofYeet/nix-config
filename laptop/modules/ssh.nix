{ config, ... }: {
  services.ssh-agent.enable = true;

  programs.ssh.addKeysToAgent = "yes";


  home.file = {
    "/home/ole/.ssh/config" = {
      text = ''

        Host uwuwhatsthis.de
          Hostname uwuwhatsthis.de
          User ole
          IdentityFile ${config.age.secrets.ssh-vps-main.path}

        Host nix-server
          Hostname 192.168.0.248
          User ole

        Host fsim-ori
          Hostname fsim.othr.de
          User beo45216
          IdentityFile ${config.age.secrets.ssh-fsim-ori.path}

        Host gitlab.oth-regensburg.de
          Hostname gitlab.oth-regensburg.de
          User git
          IdentityFile ${config.age.secrets.ssh-gitlab-oth.path}
      '';
    };
  };
}
