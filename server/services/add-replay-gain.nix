{ config, ... }:{

  imports = [
    ../pkgs/add-replay-gain/module.nix
  ];

  services.addReplayGain = {
    enable = true;
    watchDirectory = "/data/media/navidrome";
    inherit (config.serviceSettings) user group;
  };
}
