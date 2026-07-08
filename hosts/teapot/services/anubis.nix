{
  ...
}:
{
  services.anubis = {
    defaultOptions = {
      user = "anubis";
      settings = {
        SERVE_ROBOTS_TXT = true;
        WEBMASTER_EMAIL = "admin@ole.blue";
      };
    };
  };

  users.users.anubis.extraGroups = [ "nginx" ];
  users.users.nginx.extraGroups = [ "anubis" ];
}
