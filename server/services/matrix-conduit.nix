{ config, ... }:{
  age.secrets = {
    conduit-registration = { file = ../secrets/conduit_registration_token.age; };
  };

  # matrix conduit server, default port 6167
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      address = "0.0.0.0";
      server_name = "matrix.ole.blue";
      allow_registration = true;
      registration_token = builtins.readFile config.age.secrets.conduit-registration.path;
      enable_lightning_bolt = false;
    };
  };
}
