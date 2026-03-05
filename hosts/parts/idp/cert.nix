{
  ...
}:
{
  imports = [ ../dnsCerts.nix ];
  security.acme = {
    certs = {
      "idp.ole.blue" = {
        domain = "idp.ole.blue";
      };
    };
  };
}
