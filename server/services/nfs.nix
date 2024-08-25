{ ... }:
let
  apps-id = "568"; 
in {
  fileSystems."/export/navidrome" = {
    device = "/data/media/navidrome";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export             *(rw,fsid=0,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
      /export/navidrome   *(rw,nohide,insecure,no_subtree_check,all_squash,anonuid=${apps-id},anongid=${apps-id})
    '';
  };
}
