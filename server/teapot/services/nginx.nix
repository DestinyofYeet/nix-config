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

    httpConfig = ''
      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';
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
}
