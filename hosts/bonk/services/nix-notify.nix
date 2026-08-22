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
        {
          kind = "simple";
          name = "manual";
          via = "blue-email";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          packages = [
            "sonarr"
            "jellyfin"
            "shoko"
            "nextcloud"
            "etcd"
            "patroni"
            "niri"
          ];
        }
        {
          kind = "derivation";
          name = "teapot-closure";
          via = "blue-mail";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          derivation_expr = "github:DestinyofYeet/nix-config#nixosConfigurations.teapot.config.system.build.toplevel.drvPath";
          delay_minutes = 720; # 6 hours
        }
        {
          kind = "derivation";
          name = "bonk-closure";
          via = "blue-email";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          derivation_expr = "github:DestinyofYeet/nix-config#nixosConfigurations.bonk.config.system.build.toplevel.drvPath";
          delay_minutes = 720;
        }
        {
          kind = "derivation";
          name = "nix-server-closure";
          via = "blue-email";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          derivation_expr = "github:DestinyofYeet/nix-config#nixosConfigurations.nix-server.config.system.build.toplevel.drvPath";
          delay_minutes = 720;
        }
        {
          kind = "derivation";
          name = "hope-closure";
          via = "blue-email";
          recipient = "ole@ole.blue";
          feed_name = "nixos-unstable";
          derivation_expr = "github:DestinyofYeet/nix-config#nixosConfigurations.hope.config.system.build.toplevel.drvPath";
          delay_minutes = 720;
        }
      ];
    };
  };
}
