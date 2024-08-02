{ 
  pkgs, 
  ... 
} : let 
  service_dependency = "home-manager-ole.service";
in
{
  systemd.services.home-manager-ole-pre = {
    before = [ service_dependency ];
    requiredBy = [ service_dependency ];
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "home-manager-ole-pre" ''
        set -e
        
        rm_file_if_exists() {
          if [ -f "$1" ]; then
            rm "$1"
          fi
        }

        rm_file_if_exists "/home/ole/.gtkrc-2.0.backup"
      '';
      };  
    };
}
