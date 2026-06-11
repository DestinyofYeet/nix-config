{
  ...
}:
{
  services.semmelstrichliste = {
    enable = true;
    settings = {
      expectSSL = false;
      domain = "localhost";
      port = 9776;
    };

    database.type = "sqlite";
  };
}
