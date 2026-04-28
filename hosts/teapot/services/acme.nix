{ secretStore, config, ... }:
let
  secrets = secretStore.getServerSecrets "common";
in
{
  age.secrets = {
    cloudflare-api-env.file = secrets + "/cloudflare-api-env.age";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ole@ole.blue";
      dnsProvider = "cloudflare";
      group = "nginx";
      environmentFile = config.age.secrets.cloudflare-api-env.path;
    };

    certs = {
      "wildcard.teapot.neb.ole.blue" = {
        domain = "*.teapot.neb.ole.blue";
      };
    };
  };
}
