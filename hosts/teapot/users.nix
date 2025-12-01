{ ... }: {
  nix.settings.trusted-users = [ "ole" "root" "@wheel" ];

  users.users = rec {
    ole = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAo1JC8Zxama0uhbKEi+P0ifs08Kk2lL5GWqjttRZeR8 root@main"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDTPAyrp7iPzStIEQnGifJQ6JsYtD2gbE93GchJnfND ole@main"

        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZS6DFOj5KhhqW1V/orrQgmfsaPNep88DPaDNGCc0QE ole@wattson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBg88dxfhY6yzcpkGUKfYd9TMHLR59J9SsSaLYo96fKu root@wattson"
      ];

      initialPassword = "changeme";
      extraGroups = [ "wheel" ];
    };

    root.openssh.authorizedKeys = ole.openssh.authorizedKeys;
  };
}
