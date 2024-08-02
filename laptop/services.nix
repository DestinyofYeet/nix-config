{ 
  pkgs, 
  ... 
} : {
  systemd.services.home-manager-pre = {
    before = [ "home-manager-ole.service" ];

    ExecStart = pkgs.writeShellScript "home-manager-pre" ''
    #!{pkgs.bash}/bin/bash

      set -e

      rm /home/ole/.gtkrc-2.0.backup
    '';
  };  
}
