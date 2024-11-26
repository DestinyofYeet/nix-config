{ config, ... }:{

  # matrix conduit server, default port 6167
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      address = "0.0.0.0";
      server_name = "matrix.ole.blue";
      allow_registration = true;
      registration_token = config.serviceSettings.secrets.conduit.registration.token;
      enable_lightning_bolt = false;
    };
  };
}
