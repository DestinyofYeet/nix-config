{ lib, pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    envFile.text = "";

    configFile.text = ''
      $env.EDITOR = 'hx'

      $env.config = {
        show_banner: false
      }

      use task.nu
    '';
  };

  # nushell doesn't include symlinks
  home.activation =
    let
      source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nu_scripts/refs/heads/main/modules/background_task/task.nu";
        sha256 = "1k94wifbbg78lplcrww6s2bmblknm5jxzyk26qca3w215g7q85d5";
      };
    in
    {
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
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.pueue}/bin/pueued";
      };
    };
  };
}
