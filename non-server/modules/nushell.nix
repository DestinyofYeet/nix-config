{
  lib,
  pkgs,
  current-specialisation,
  ...
}: {
  programs.nushell = {
    enable = true;

    envFile.text = "";

    configFile.text = ''
      $env.EDITOR = 'hx'

      $env.config = {
        show_banner: false
      }

      $env.config.history = {
        file_format: "sqlite"
        sync_on_enter: true
        isolation: true
      }

      def --wrapped build-system [ function: string, ...args ] {
        sudo -v
        sudo nixos-rebuild $function ...$args --flake /home/ole/nixos# --log-format internal-json -v o+e>| nom --json
      }

      def --wrapped rebuild-system [ ...args ] {
        build-system switch ...$args --specialisation ${current-specialisation}
      }

      def --wrapped test-system [ ...args ] {
        build-system test ...$args --specialisation ${current-specialisation}
      }


      use task.nu
    '';
  };

  # nushell doesn't include symlinks
  home.activation = let
    source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nushell/nu_scripts/ba13f5ca600ee537880674e065ad237a89161e97/modules/background_task/task.nu";
      sha256 = "05lafp08fvv22kb6k2npg0g25jpwdz1myz3aaqwslxcab4ivfbgw";
    };
  in {
    write-task-file = ''
      ${lib.custom.update-needed-content-file}/bin/update-needed-content-file "${source}" "/home/ole/.config/nushell/scripts/task.nu"
    '';
  };

  systemd.user.services = {
    pueued = {
      Unit = {
        Description = "Pueued Service";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.pueue}/bin/pueued";
      };
    };
  };
}
