{ config, ... }:
let
  apps-id = config.serviceSettings.uid;
  apps-gid = config.serviceSettings.gid;
in
{
  # fileSystems = {
  #   "/export/navidrome" = {
  #     depends = [
  #       "${config.serviceSettings.paths.data}/media/navidrome"
  #     ];
  #     device = "${config.serviceSettings.paths.data}/media/navidrome";
  #     options = [ "bind" ];
  #   };

  #   "/export/programmingStuff" = {
  #     depends = [
  #       "${config.serviceSettings.paths.data}/Programming-Stuff"
  #     ];
  #     device = "${config.serviceSettings.paths.data}/Programming-Stuff";
  #     options = [ "bind" ];
  #   };
  # };

  services.nfs.server = {
    enable = true;
    # exports = ''
    #   /export             *(rw,nohide,insecure,fsid=0,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-gid})
    #   /export/navidrome   *(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-gid})
    #   /export/programmingStuff   *(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-gid})
    # '';
  };
}
