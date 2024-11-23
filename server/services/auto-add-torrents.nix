{
  config,
  ...
}:{

  age.secrets = {
    auto-add-torrents-conf = {
      file = ../secrets/auto-add-torrents.conf.age;
      owner = config.services.auto-add-torrents.user;
      group = config.services.auto-add-torrents.group;
    };
  };
  
  services.auto-add-torrents = {
    enable = true;
    configFile = config.age.secrets.auto-add-torrents-conf.path;
    developerMode = false;
  };

  systemd.services.auto-add-torrents = {
    after = [ "prowlarr.service" ];
    requires = [ "prowlarr.service" ];
  };
}
