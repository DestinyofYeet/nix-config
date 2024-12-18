{ config, ... }:
{
  age.secrets = {
    users-ole-password = {
      file = ./../secrets/ankisync-users-ole.age;
    };
  };

  services.anki-sync-server = {
    enable = true;
    address = "0.0.0.0";

    users = [
      {
        username = "ole";
        passwordFile = config.age.secrets.users-ole-password.path;
      }
    ];
  };
}
