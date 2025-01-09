{
  ...
}:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    clientMaxBodySize = "256m";

    mapHashBucketSize = 128;
    mapHashMaxSize = 1024;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ole@uwuwhatsthis.de";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };

  services.prometheus.exporters.nginx = {
    enable = true;
  };
}
