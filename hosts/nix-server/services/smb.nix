{ ... }:
{
  services.samba = {
    enable = true;

    settings = {
      data = {
        path = "/mnt/data/data";
        "read only" = "yes";
        "force user" = "apps";
        "force groups" = "apps";
      };
    };
  };
}
