{ ... }:
{
  imports = [
    ./openssh.nix
    ./argoneon.nix
    ./smartd.nix
  ];

  home-manager.users.autologin = ./hm-manager.nix;
}
