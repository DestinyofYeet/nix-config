{ lib, pkgs, ... }:
let
  bluetooth-udev = pkgs.writeScript "bluetooth-udev" ''
    if [[ ! $NAME =~ ^\"([0-9A-F]{2}[:-]){5}([0-9A-F]{2})\"$ ]]; then exit 0; fi

    action=$(expr "$ACTION" : "\([a-zA-Z]\+\).*")

    if [ "$action" = "add" ]; then
        ${pkgs.bluez}/bin/bluetoothctl discoverable off
    fi

    if [ "$action" = "remove" ]; then
        ${pkgs.bluez}/bin/bluetoothctl discoverable on
    fi
  '';

  post-start = pkgs.writeScript "bt-post-start" ''
    echo "Attempting to connect to previous devices"
    CONTROLLER=`ls /var/lib/bluetooth`
    CLIENTS=`ls -t /var/lib/bluetooth/$CONTROLLER/cache`

    for CLIENT in $CLIENTS; do
        echo "Attempting $CLIENT"
        if ${pkgs.bluez}/bin/bluetoothctl connect $CLIENT; then break; fi
    done
  '';

  bt-pins = pkgs.writeText "bt-pins" ''
    * *
  '';
in {
  hardware.raspberry-pi."4" = { apply-overlays-dtmerge.enable = true; };

  boot.kernelParams = [ "snd_bcm2835.enable_headphones=1" ];

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        FastConnectable = true;
      };

      Policy = { AutoEnable = true; };
    };
  };

  hardware.deviceTree = {
    enable = true;
    overlays = [
      {
        name = "disable-wifi";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          /{
              compatible = "raspberrypi,4-model-b";
              fragment@0 {
                  target = <&mmc>;
                  __overlay__ {
                      status = "disabled";
                  };
              };
              fragment@1 {
                  target = <&mmcnr>;
                  __overlay__ {
                      status = "disabled";
                  };
              };
          };
        '';
      }
      # Based on disable-bt-overlay.dts
      {
        name = "disable-bt";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          /{
              compatible = "raspberrypi,4-model-b";
              fragment@0 {
                  target = <&bt>;
                  __overlay__ {
                      status = "disabled";
                  };
              };
          };
        '';
      }
      {
        name = "audio";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
              compatible = "brcm,bcm2835";

              fragment@0 {
                  target-path = "/";
                  __overlay__ {
                      pwm_audio: pwm_audio {
                          compatible = "brcm,bcm2835-audio";
                          brcm,auxsrc = <0>;   /* 0 = PWM audio */
                      };
                  };
              };
          };
        '';
      }
      {
        name = "no-hdmi-out";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
              compatible = "brcm,bcm2835";

              fragment@0 {
                  target-path = "/";
                  __overlay__ {
                      hdmi_ignore_edid_audio: hdmi_ignore_edid_audio {
                          compatible = "raspberrypi,firmware-params";
                          hdmi_ignore_edid_audio = <1>;
                      };
                  };
              };
          };
        '';
      }
    ];
  };

  systemd.services = {
    "bt-agent" = {
      description = "Bluetooth Agent";
      requires = [ "bluetooth.service" ];
      after = [ "bluetooth.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStartPre = [
          "${pkgs.busybox}/bin/sleep 2"
          "${pkgs.bluez}/bin/bluetoothctl discoverable on"
        ];

        ExecStart =
          "${pkgs.bluez-tools}/bin/bt-agent --capability=DisplayOnly -p ${bt-pins}";

        Restart = "always";
        RestartSec = 5;
      };
    };

    "bt-agent-post" = {
      description = "Autoconnect to previous devices";
      after = [ "bt-agent.service" "pulseaudio.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash ${post-start}";
      };
    };
  };

  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    systemWide = true;

    # configFile = pkgs.writeText "default.pa" ''
    #   load-module module-bluetooth-policy
    #   load-module module-bluetooth-discover
    #   ## module fails to load with 
    #   ##   module-bluez5-device.c: Failed to get device path from module arguments
    #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    #   # load-module module-bluez5-device
    #   # load-module module-bluez5-discover
    # '';
  };

  environment.systemPackages = with pkgs; [ alsa-utils pulseaudio ];

  services.udev.extraRules = ''
    SUBSYSTEM=="input", GROUP="input", MODE="0660"
    KERNEL=="input[0-9]*", RUN+="${bluetooth-udev}"
  '';

  boot.initrd = {
    allowMissingModules = true;

    supportedFilesystems.zfs = lib.mkForce false;
  };

  networking = {
    wireless.enable = false;
    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  sdImage.compressImage = false;

  users = {
    users = {
      root.password = "pi";
      pi = {
        isNormalUser = true;
        initialPassword = "pi";
        extraGroups = [ "pipewire" ];
      };
    };
  };

  system.stateVersion = "25.11";

  time.timeZone = "Europe/Berlin";

  networking.hostName = "MusicPi";
}
