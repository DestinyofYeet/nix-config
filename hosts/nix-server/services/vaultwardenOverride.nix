{
  lib,
  ...
}:
{
  services.vaultwarden.config.DATA_DIR = lib.mkForce "/mnt/data/data/vaultwarden/data";
}
