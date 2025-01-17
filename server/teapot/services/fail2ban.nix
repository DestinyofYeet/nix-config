{
  ...
}:
{
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "37.4.229.171"
      "10.100.0.0/24"
    ];

    jails =
      let
        default-settings = {
          maxretry = 5;
        };
      in
      {
        nginx-http-auth = {
          settings = default-settings // {
            port = "http,https";
          };
        };

        sshd = {
          settings = default-settings;
        };

        dovecot = {
          settings = default-settings;
        };

        postfix = {
          settings = default-settings;
        };
      };
  };
}
