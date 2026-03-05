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
    script = ''
      ${lib.getExe pkgs.rsync} -Pav -r -e "${lib.getExe' pkgs.openssh "ssh"} -o \"StrictHostKeyChecking no\" -o UserKnownHostsFile=/dev/null -i ${config.age.secrets.vaultwarden-sync-key.path}"  vaultwarden@teapot.neb.ole.blue:* ${config.services.vaultwarden.config.DATA_DIR}
    '';

    serviceConfig = {
      User = "vaultwarden";
      Group = "vaultwarden";
    };
  };

  systemd.timers."sync-vaultwarden-attachments" = {
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnCalendar = "minutely";
    };
  };
}
