{ config, ... }: {
  services.ssh-agent.enable = true;

  programs.ssh.addKeysToAgent = "yes";


  home.file = {
    "/home/ole/.ssh/config" = {
      text = ''
        IdentityFile ${config.age.secrets.ssh-gitlab-oth.path}

        Host uwuwhatsthis.de
          Hostname uwuwhatsthis.de
          User ole
          IdentityFile ${config.age.secrets.ssh-vps-main.path}

        Host nix-server
          Hostname 192.168.0.248
          User ole
      '';
    };
  };
}
