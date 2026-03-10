{
  pkgs,
  config,
  lib,
  secretStore,
  ...
}:
let
  secrets = secretStore.getServerSecrets "common";
in
lib.mkIf (config.services.vaultwarden.enable) {
  age.secrets = {
    vaultwarden-sync-key = {
      file = secrets + "/vaultwarden-sync-key.age";
      owner = "vaultwarden";
      group = "vaultwarden";
    };
  };

  systemd.services."sync-vaultwarden-attachments" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    script = ''
      while true
      do
        ${lib.getExe pkgs.rsync} -Pav -r -e "${lib.getExe' pkgs.openssh "ssh"} -o \"StrictHostKeyChecking no\" -o UserKnownHostsFile=/dev/null -i ${config.age.secrets.vaultwarden-sync-key.path}"  vaultwarden@teapot.neb.ole.blue:* ${config.services.vaultwarden.config.DATA_DIR}
        sleep 60
      done
    '';

    serviceConfig = {
      User = "vaultwarden";
      Group = "vaultwarden";
      Restart = "on-failure";
    };
  };
}
