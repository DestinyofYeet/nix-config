{ config, secretStore, ... }:
let secrets = secretStore.getServerSecrets "common";
in {
  age.secrets = {
    cloudflare-api-env = { file = secrets + "/cloudflare-api-env.age"; };
  };

  # on the basis of https://www.youtube.com/watch?v=qlcVx-k-02E
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ole@ole.blue";

      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      group = "nginx";
      environmentFile = config.age.secrets.cloudflare-api-env.path;
    };

    certs = {
      "wildcard.local.ole.blue" = {
        domain = "*.local.ole.blue";
        dnsProvider = "cloudflare";
      };

      "local.ole.blue" = {
        environmentFile = config.age.secrets.cloudflare-api-env.path;
        dnsProvider = "cloudflare";
        domain = "local.ole.blue";
      };
    };
  };
}
