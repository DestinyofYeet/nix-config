{
  ...
}:
{
  services.strichliste = {
    enable = true;

    databaseDir = "/var/lib/strichliste/db";
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.docker.enable = true;
}
