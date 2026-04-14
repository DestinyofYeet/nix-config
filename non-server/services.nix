{ pkgs, lib, ... }:
let
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
        rm_file_if_exists "/home/ole/.config/xsettingsd/xsettingsd.conf.backup"
        rm_file_if_exists "/home/ole/.config/mimeapps.list.backup"
        rm_file_if_exists "/home/ole/.config/fontconfig/conf.d/10-hm-fonts.conf.backup"
      '';
    };
  };

  networking.firewall = {
    enable = false;
  };

  services.pcscd.enable = true;

  services.solaar.enable = true;
}
