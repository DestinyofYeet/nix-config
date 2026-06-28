{
  lib,
  ...
}:
{
  services.nginx.virtualHosts."status.local.ole.blue" = {
    enableACME = lib.mkForce false;
    useACMEHost = "wildcard.local.ole.blue";
  };
}
