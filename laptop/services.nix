{ 
  pkgs, 
  ... 
} : let 
  service_name = "home-manager-ole.service";
in
{
  systemd.services.home-manager-pre = {
    before = [ service_name ];
    requiredBy = [ service_name ];
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "home-manager-pre" ''
        #!{pkgs.bash}/bin/bash

        set -e

        rm /home/ole/.gtkrc-2.0.backup
      '';
      };  
    };
}
