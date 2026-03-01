{ pkgs, ... }:
{

  hardware.raspberry-pi.config.all.base-dt-params = {
    i2c_arm = {
      enable = true;
      value = "on";
    };
    audio = {
      enable = true;
      value = "on";
    };
  };

  boot.kernelModules = [ "i2c_bcm2835" ];

  programs.argon = {
    one = {
      enable = true;

      settings = {
        oled = {
          screenList = [ "ip" ];
          switchDuration = 30;
        };

        displayUnits = "celsius";

        fanspeed = [
          {
            temperature = 70;
            speed = 10;
          }

          {
            temperature = 80;
            speed = 50;
          }

          {
            temperature = 90;
            speed = 100;
          }
        ];
      };
    };

    eon.enable = true;
  };
}
