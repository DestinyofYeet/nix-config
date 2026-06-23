{
  ...
}:
{
  services.semmelstrichliste = {
    enable = false;
    settings = {
      expectSSL = false;
      domain = "localhost";
      port = 9776;
    };

    database.type = "sqlite";
  };
}
