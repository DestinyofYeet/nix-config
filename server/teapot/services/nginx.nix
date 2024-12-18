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

    # virtualHosts."ole.blue" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = {
    #     # for the basic nginx hello page
    #   };
    # };
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
