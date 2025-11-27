{ secretStore, config, ... }:
let commonSecrets = secretStore.getServerSecrets "common";
in {
  age.secrets = {
    cloudflare-api-env = { file = commonSecrets + "/cloudflare-api-env.age"; };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ole@ole.blue";

      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      group = "nginx";
      environmentFile = config.age.secrets.cloudflare-api-env.path;
    };

    certs = { "idp.ole.blue" = { domain = "idp.ole.blue"; }; };
  };
}
