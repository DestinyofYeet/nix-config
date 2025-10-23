{ pkgs, lib, ... }: {

  systemd.services."disable-pen" = {
    script = ''
      line=$(${
        lib.getExe pkgs.libinput
      } list-devices | grep -i "Wacom HID 5365 Pen" -A 1 | grep -i "Kernel")
      ${lib.getExe pkgs.evtest} --grab ''${line#"Kernel: "} > /dev/null
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
