{ pkgs, lib, osConfig, capabilities, ... }: {
  programs.ashell = {
    enable = true;
    systemd.enable = true;

    settings = {
      modules = {

        left = [ "Workspaces" ];
        center = [ "Clock" ];
        right = [ "SystemInfo" "Settings" "Tray" ];
      };

      workspaces = { visibility_mode = "MonitorSpecific"; };
      clock = { format = "%a %d.%m %H:%M"; };
      system_info = rec {
        indicators = [ "Cpu" "Memory" ]
          ++ (lib.optionals (lib.custom.isLaptop osConfig) [ "Temperature" ]);

        cpu = {
          warn_threshold = 80;
          alert_threshold = 90;
        };

        memory = cpu;
        temperature = cpu;
      };
      settings = lib.mkMerge [
        {
          audio_sinks_more_cmd = "${lib.getExe pkgs.pavucontrol} -t 3";
          audio_sources_more_cmd = "${lib.getExe pkgs.pavucontrol} -t 4";
        }
        (lib.mkIf (capabilities.bluetooth.enable) {
          bluetooth_more_cmd = "${pkgs.blueman}/bin/blueman-manager";
        })

        (lib.mkIf (!capabilities.wifi.enable) { remove_airplane_btn = true; })

        (lib.mkIf (capabilities.wifi.enable) { remove_airplane_btn = false; })
      ];

      appearance = {
        opacity = 0.5;
        success_color = "#a6e3a1";
        text_color = "#00EEFF";

        primary_color = {
          base = "#fab387";
          text = "#1e1e2e";
        };

        danger_color = {
          base = "#f38ba8";
          weak = "#f9e2af";
        };

        background_color = {
          base = "#1e1e2e";
          weak = "#313244";
          strong = "#45475a";
        };

        secondary_color = {
          base = "#11111b";
          strong = "#1b1b25";
        };
      };
    };
  };
}
