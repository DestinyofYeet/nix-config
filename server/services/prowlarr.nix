{ pkgs, config, ... }:{

  systemd.services.prowlarr = {
    description = "Prowlarr";
    wantedBy = [ "multi-user.target" ];

    enable = true;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = config.serviceSettings.user;
      Group = config.serviceSettings.group;
      ExecStart =
        "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${config.serviceSettings.paths.configs}/prowlarr";
    };
  };
}
