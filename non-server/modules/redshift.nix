{ ... }: {
  services.gammastep = {
    enable = true;
    dawnTime = "06:00-07:00";
    duskTime = "22:00-23:00";

    temperature = {
      day = 8000;
      night = 3700;
    };

    tray = true;
  };
}
