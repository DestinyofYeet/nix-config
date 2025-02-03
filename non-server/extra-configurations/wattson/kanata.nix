{...}: let
  # buildAlias = key: remap: "${key} (multi f24 (tap-hold $tap-time $hold-time ${key} ${remap}))";
  buildAlias = key: remap: "(tap-hold $tap-time $hold-time ${key} ${remap})";
in {
  services.kanata = {
    enable = true;

    keyboards = {
      laptop-kbd = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        extraDefCfg = ''
          process-unmapped-keys yes
        '';

        config = ''
          (defsrc
            s l d k f j
          )

          (defvar
            tap-time 150
            hold-time 200
          )

          (defalias
            sr ${buildAlias "s" "lctl"}
            lr ${buildAlias "l" "rctl"}
            dr ${buildAlias "d" "lsft"}
            kr ${buildAlias "k" "rsft"}
            fr ${buildAlias "f" "lmet"}
            jr ${buildAlias "j" "lmet"}
          )

          (deflayer base
            @sr @lr @dr @kr @fr @jr
          )
        '';
      };
    };
  };

  # Enable the uinput module
  boot.kernelModules = ["uinput"];

  # Enable uinput
  hardware.uinput.enable = true;

  # Set up udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Ensure the uinput group exists
  users.groups.uinput = {};

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };
}
