{ stable-pkgs, ... }: {
  services.nextcloud-client = {
    enable = true;
    # package = stable-pkgs.nextcloud-client;
    startInBackground = true;
  };
}
