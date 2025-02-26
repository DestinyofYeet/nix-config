{ pkgs, ... }:
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

  # # for connecting to my innernet network
  # systemd.services.innernet-infra = {
  #   enable = true;
  #   description = "innernet client for infra";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [
  #     "network-online.target"
  #     "nss-lookup.target"
  #   ];
  #   wants = [
  #     "network-online.target"
  #     "nss-lookup.target"
  #   ];
  #   serviceConfig = {
  #     Restart = "always";
  #     ExecStart = "${pkgs.innernet}/bin/innernet up infra --daemon --interval 60 --no-write-hosts";
  #   };
  # };

  # services.fwupd.enable = true;

  services.pcscd.enable = true;

  # ipfs
  # services.kubo.enable = true;
}
