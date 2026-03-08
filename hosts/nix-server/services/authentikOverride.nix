{
  lib,
  ...
}:
{
  # migrations should only run on one host (teapot in this case)
  systemd.services."authentik-migrate".enable = lib.mkForce false;
  systemd.services."authentik".requires = lib.mkForce [ "authentik-worker.service" ];
}
