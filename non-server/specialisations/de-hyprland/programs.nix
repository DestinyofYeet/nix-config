{ pkgs, lib, ... }: {
  programs.iio-hyprland.enable = true;
  # disables ssh-agent because it just tries all ssh-keys on a server and then gets disconnected because it tried the wrong ones too often
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ wvkbd ];
}
