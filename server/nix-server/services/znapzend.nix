{
  ...
}:
{
  services.znapzend = {
    enable = true;
    pure = true;
    features.skipIntermediates = true;
    zetup = {
      "data/data/photos" = {
        plan = "1m=>1d";
        recursive = true;

        destinations.local = {
          dataset = "ARCHIVE/photos";
          presend = "zfs mount -R ARCHIVE";
        };
      };
    };
  };
}
