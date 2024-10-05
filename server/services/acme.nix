{
  config,
  ...
}:{
  age.secrets = {
    porkbun-api-env = { file = ../secrets/porkbun-api-env.age; };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ole@uwuwhatsthis.de";
    certs = {
      "wildcard.local.ole.blue" = {
        dnsProvider = "porkbun";
        environmentFile = config.age.secrets.porkbun-api-env.path;
        domain = "*.local.ole.blue";
      };

      "local.ole.blue" = {
        dnsProvider = "porkbun";
        environmentFile = config.age.secrets.porkbun-api-env.path;
      };
    };
  };
}
