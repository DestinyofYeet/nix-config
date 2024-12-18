{ ... }:
{
  services.engelsystem = {
    enable = false;

    settings = {
      database = {
        database = "engelsystem";
        host = "localhost";
        username = "engelsystem";
      };

      footer_items = {
        FAQ = null;
        Contact = null;
      };
    };

    domain = "engel.nix-server.infra.wg";
  };
}
