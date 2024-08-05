{ ... }:{
  age.identityPaths = [ "/home/ole/.ssh/id_ed25519" ];

  age.secrets = {
    ssh-gitlab-oth = {
      file = ../secrets/ssh-key-oth-gitlab.age;
    };
    ssh-vps-main = {
      file = ../secrets/ssh-key-vps-main.age;
    };
  };
}
