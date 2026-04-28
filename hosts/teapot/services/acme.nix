{ secretStore, config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ole@ole.blue";
      dnsProvider = "cloudflare";
      group = "nginx";

      # set in hosts/parts/dnsCerts.nix
      environmentFile = config.age.secrets.cloudflare-api-env.path;
    };

    certs = {
      "wildcard.teapot.neb.ole.blue" = {
        domain = "*.teapot.neb.ole.blue";
      };
    };
  };
}
