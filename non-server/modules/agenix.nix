{ ... }:{
  age = {
    identityPaths = [ "/home/ole/.ssh/id_ed25519" ];

    secretsDir = "/home/ole/.agenix/agenix";
    secretsMountPoint = "/home/ole/.agenix/agenix.d";

    secrets = {
      stalwart-ole-pw = {
        file = ../secrets/stalwart-ole-pw.age;
      };
    };
  };
}
