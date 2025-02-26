{ ... }:
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

    streamConfig = ''
      server {
        listen 0.0.0.0:2222;

        proxy_pass 10.100.0.6:22;
      }
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ole@ole.blue";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      2222
    ];
  };

  services.prometheus.exporters.nginx = {
    enable = true;
  };
}
