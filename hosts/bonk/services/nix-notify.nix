{
  config,
  secretStore,
  ...
}:
let
  secrets = secretStore.getHostSecrets "bonk";
in
{
  age.secrets =
    let
      common = {
        owner = config.services.nix-notify.user;
      };
    in
    {
      nixNotifyGithub = {
        file = secrets.getSecret "nix-notify-github";
      }
      // common;

      nixNotifyEmail = {
        file = secrets.getSecret "nix-notify-email";
      }
      // common;
    };

  services.nix-notify = {
    enable = true;

    settings = {
      general = {
        github_api_token = "@:${config.age.secrets.nixNotifyGithub.path}";
      };

      feeds = [
        {
          name = "nixos-unstable";
          delay_minutes = 10;
          source = "nixpkgs";
          kind = "github_api";
        }
        {
          name = "master";
          delay_minutes = 2;
          source = "nixpkgs";
          kind = "github_atom";
        }
        # {
        #   name = "nixos-26.05";
        #   delay_minutes = 2;
        #   source = "nixpkgs";
        #   kind = "github_atom";
        # }
      ];

      notifications = [
        rec {
          name = "blue-mail";
          kind = "email";
          smtp_host = "mail.ole.blue";
          smtp_port = 465;
          envelope_from = "scripts@uwuwhatsthis.de";
          login_username = envelope_from;
          login_password = "@:${config.age.secrets.nixNotifyEmail.path}";
        }
      ];

      subscriptions = [
        # {
        #   via = "blue-mail";
        #   recipient = "ole@ole.blue";
        #   feed_name = "master";
        #   packages = [
        #     "mastodon"
        #   ];
        # }
        {
          via = "blue-mail";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          packages = [
            "mastodon"
            "forgejo"
            "nginx"
            "nginxMainline"
            "deluge"
            "qbittorrent-nox"
          ];
        }
      ];
    };
  };
}
