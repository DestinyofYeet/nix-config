{ config, ... }:
{
  age.secrets = {
    auto-add-torrents-conf = {
      file = ../secrets/auto-add-torrents.conf.age;
    };
  };

  systemd.services.auto-add-torrents = {
    after = [ "prowlarr.service" ];
    requires = [ "prowlarr.service" ];
  };

  services.auto-add-torrents = {
    enable = false;
    configFile = config.age.secrets.auto-add-torrents-conf.path;
  };
}
