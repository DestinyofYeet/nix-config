{ ... }:{

  imports = [
    ../pkgs/add-replay-gain/module.nix
    ./settings.nix
  ];

  services.addReplayGain = {
    enable = true;
    watchDirectory = "/data/media/navidrome";
    inherit (customServiceSettings) user group;
  };
};
