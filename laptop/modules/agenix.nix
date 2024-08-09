{ ... }:{
  age = {
    identityPaths = [ "/home/ole/.ssh/id_ed25519" ];

    secretsDir = "/home/ole/.agenix/agenix";
    secretsMountPoint = "/home/ole/.agenix/agenix.d";

    secrets = {
      ssh-gitlab-oth = {
        file = ../secrets/ssh-key-oth-gitlab.age;
      };
      ssh-vps-main = {
        file = ../secrets/ssh-key-vps-main.age;
      };

      ssh-fsim-ori = {
        file = ../secrets/ssh-key-fsim-ori.age;
      };

      stalwart-ole-pw = {
        file = ../secrets/stalwart-ole-pw.age;
      };
    };
  };
}
