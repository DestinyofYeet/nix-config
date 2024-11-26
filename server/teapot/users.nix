{
  ...
}:{
  nix.settings.trusted-users = [
    "ole"
  ];

  users.users.ole = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAo1JC8Zxama0uhbKEi+P0ifs08Kk2lL5GWqjttRZeR8 root@main"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDTPAyrp7iPzStIEQnGifJQ6JsYtD2gbE93GchJnfND ole@main"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkPxsSPtso+b6Cwn7oxpwHxjzauASSlM1YZaEI6LP+t ole@wattson"
    ];

    initialPassword = "changeme";
    extraGroups = [ "wheel" ];
  };
}
