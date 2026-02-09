{ config, secretStore, ... }:
let
  secrets = secretStore.getServerSecrets "teapot";
  matrixPort = 8008;
  matrixAddr = "127.0.0.1";
in
{

  age.secrets =
    let
      matrixSettings = config.services.matrix-tuwunel;

      matrixOwner = {
        owner = matrixSettings.user;
        group = matrixSettings.group;
      };
    in
    {
      matrix-registration-token = {
        file = secrets + "/matrix-registration-token.age";
      }
      // matrixOwner;

      matrix-turn-secret = {
        file = secrets + "/matrix-turn-secret.age";
      }
      // matrixOwner;

      matrix-oauth-secret = {
        file = secrets + "/matrix-oauth_client_secret.age";
      }
      // matrixOwner;
    };

  services.matrix-tuwunel = {
    enable = true;
    stateDirectory = "matrix-conduit"; # backwards-compatibility

    settings = {
      global = {

        address = [ matrixAddr ];
        port = [ matrixPort ];

        server_name = "matrix.ole.blue";

        new_user_displayname_suffix = "";

        allow_registration = true;

        registration_token_file = config.age.secrets.matrix-registration-token.path;

        allow_federation = true;

        trusted_servers = [
          "matrix.org"
          "vector.im"
        ];

        well_known = {
          client = "https://matrix.ole.blue";
          server = "matrix.ole.blue:443";

          rtc_transports = [
            {
              type = "livekit";
              livekit_service_url = "https://matrix.ole.blue/livekit/jwt";
            }
          ];
        };

        turn_secret_file = config.age.secrets.matrix-turn-secret.path;

        turn_uris = [
          "turn:turn.ole.blue?transport=udp"
          "turn:turn.ole.blue?transport=tcp"
        ];

        # does not seem to work currently
        # identity_provider = [
        #   {
        #     brand = "Authentik";
        #     name = "Authentik";
        #     client_id = "2FNVm2pCGCsdtynQE1gd2l15hIoiPq4L2tvhq86H";
        #     issuer_url = "https://idp.ole.blue/application/o/matrix/";
        #     base_path = "/application/o/matrix";
        #     callback_url = "https://matrix.ole.blue/_matrix/client/unstable/login/sso/callback/2FNVm2pCGCsdtynQE1gd2l15hIoiPq4L2tvhq86H";
        #     client_secret_file = config.age.secrets.matrix-oauth-secret.path;
        #   }
        # ];
      };
    };
  };

  services.nginx.virtualHosts = {
    "matrix.ole.blue" = {
      enableACME = true;
      forceSSL = true;

      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8448;
          ssl = true;
        }
      ];

      locations."/" = {
        proxyPass = "http://${matrixAddr}:${toString matrixPort}";
        proxyWebsockets = true;
        recommendedProxySettings = true;

        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
    };
  };
}
