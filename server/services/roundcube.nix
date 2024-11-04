{
  config,
  ...
}:{
  services.roundcube = {
    enable = true;
    hostName = "webmail.local.ole.blue";
    extraConfig = ''
      $config['smtp_server'] = "tls://mx.uwuwhatsthis.de";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';

    configureNginx = true;
  };

  services.nginx.virtualHosts."${config.services.roundcube.hostName}" = {
    useACMEHost = config.serviceSettings.nginx-local-ssl.useACMEHost;
    enableACME = false;
  };
}
