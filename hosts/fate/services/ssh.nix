{ secretStore, ... }: {
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = secretStore.keys.authed;
}
