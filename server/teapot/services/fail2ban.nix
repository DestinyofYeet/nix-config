{
  ...
}:{
  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "37.4.229.171"
    ];

    jails = {
      nginx-http-auth = {
        settings = {
          maxretry = 5;
          port = "http,https";
        };
      };

      sshd = {
        settings = {
          maxretry = 5;
        };
      };
    };
  };
}
