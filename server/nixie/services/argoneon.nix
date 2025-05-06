{ ... }: {
  programs.argon = {
    one = {
      enable = true;

      settings = {
        oled = {
          screenList = [ "temp" "ip" ];
          switchDuration = 30;
        };
      };
    };

    eon.enable = true;
  };
}
