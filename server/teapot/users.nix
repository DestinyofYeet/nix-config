{
  ...
}:{
  users.users.ole = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDTPAyrp7iPzStIEQnGifJQ6JsYtD2gbE93GchJnfND ole@main"
    ];

    initialPassword = "changeme";
    extraGroups = [ "wheel" ];
  };
}
