{ ... }: {
  programs.argon = {
    one = {
      enable = true;

      settings = {
        oled = {
          screenList = [ "ip" ];
          switchDuration = 30;
        };
      };
    };

    eon.enable = true;
  };
}
