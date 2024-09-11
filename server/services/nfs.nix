{ config, ... }:
let
  apps-id = "568"; 
in {
  fileSystems."/export/navidrome" = {
    device = "${config.serviceSettings.paths.data}/media/navidrome";
    options = [ "bind" ];
  };

  fileSystems."/export/programmingStuff" = {
    device = "${config.serviceSettings.paths.data}/Programming-Stuff";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export             *(rw,fsid=0,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
      /export/navidrome   *(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
      /export/programmingStuff   *(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
    '';
  };
}
