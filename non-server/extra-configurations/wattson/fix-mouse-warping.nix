{ pkgs, lib, ... }: {

  systemd.services."disable-pen" = {
    script = ''
      ${lib.getExe pkgs.evtest} --grab /dev/input/event8 > /dev/null
    '';
    wantedBy = [ "multi-user.target" ];
  };

  security.sudo.extraRules = let
    noPasswordOptions = [ "SETENV" "NOPASSWD" ];
    systemctl = "/run/current-system/sw/bin/systemctl";
  in [{
    users = [ "ole" ];
    commands = [
      {
        command = "${systemctl} start disable-pen";
        options = noPasswordOptions;
      }
      {
        command = "${systemctl} stop disable-pen";
        options = noPasswordOptions;
      }
    ];
  }];

}
