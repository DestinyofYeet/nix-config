{
  lib,
  ...
}:
{

  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
