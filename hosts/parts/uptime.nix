domain:
{
  flake,
  ...
}:
{
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyWebsockets = true;

      proxyPass = "http://nix-server.neb.ole.blue:${flake.nixosConfigurations.nix-server.config.services.uptime-kuma.settings.PORT}";
    };
  };
}
