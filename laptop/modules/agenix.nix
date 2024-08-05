{ ... }:{
  age.identityPaths = [ "/home/ole/.ssh/id_ed25519" ];

  age.secrets = {
    ssh-gitlab-oth = {
      file = ../secrets/ssh-key-oth-gitlab.age;
    };
  };
}
