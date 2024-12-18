{ ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
  };

  users.extraGroups.docker.members = [ "ole" ];
}
