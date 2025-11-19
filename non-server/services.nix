{ pkgs, lib, ... }:
let service_dependency = "home-manager-ole.service";
in {
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

  networking.firewall = { enable = false; };

  services.pcscd.enable = true;

  # https://github.com/PixlOne/logiops/issues/520
  systemd.services."logid" = let
    cfg = pkgs.writers.writeText "logid.cfg" ''
          devices: (
      {
          name: "MX Master 4 for Mac";
          dpi: 800;
          smartshift:
          {
              on: true;
              threshold: 3;
              torque: 50;
          };
          hiresscroll:
          {
              hires: true;
              invert: false;
              target: false;
              up: {
                  mode: "Axis";
                  axis: "REL_WHEEL_HI_RES";
                  axis_multiplier: 0.25;
              },
              down: {
                  mode: "Axis";
                  axis: "REL_WHEEL_HI_RES";
                  axis_multiplier: -0.25;
              },
          };

          thumbwheel: {
            invert: true;
          }
        })
    '';
  in {
    script = ''
      ${lib.getExe pkgs.logiops} -c ${cfg}
    '';

    wantedBy = [ "multi-user.target" ];
  };
}
