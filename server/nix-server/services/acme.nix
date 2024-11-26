{
  config,
  ...
}:{
  age.secrets = {
    porkbun-api-env = { file = ../secrets/porkbun-api-env.age; };
  };

  # on the basis of https://www.youtube.com/watch?v=qlcVx-k-02E
  security.acme = {
    acceptTerms = true;
    defaults.email = "ole@uwuwhatsthis.de";
    certs = {
      "wildcard.local.ole.blue" = {
        group = "nginx";
        dnsProvider = "porkbun";
        environmentFile = config.age.secrets.porkbun-api-env.path;
        domain = "*.local.ole.blue";
      };

      "local.ole.blue" = {
        group = "nginx";
        dnsProvider = "porkbun";
        environmentFile = config.age.secrets.porkbun-api-env.path;
      };
    };
  };
}
