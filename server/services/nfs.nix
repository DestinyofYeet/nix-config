{ ... }:
let
  apps-id = 568; 
in {
  fileSystems."/nfs/navidrome" = {
    device = "/data/media/navidrome";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export             192.168.0.0/24(rw,fsid=0,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
      /export/navidrome   192.168.0.0/24(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
    '';
  };
};
