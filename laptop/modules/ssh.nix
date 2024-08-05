{ config, ... }: {
  services.ssh-agent.enable = true;

  programs.ssh.addKeysToAgent = "yes";


  home.file = {
    "/home/ole/.ssh/config" = {
      text = ''
        Host gitlab-oth
          Hostname gitlab.oth-regensburg.de
          User beo45216
          IdentityFile ${config.age.secrets.ssh-gitlab-oth.path}

        Host uwuwhatsthis.de
          Hostname uwuwhatsthis.de
          User ole
          IdentityFile ${config.age.secrets.ssh-vps-main.path}
      '';
    };
  };
}
