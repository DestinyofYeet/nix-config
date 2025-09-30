{ ... }: {
  # maybe: https://gist.github.com/Dregu/6a6021bda7108b3e063d05ad7407f914
  services.sunshine = {
    enable = true;

    autoStart = true;
    capSysAdmin =
      true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
}
