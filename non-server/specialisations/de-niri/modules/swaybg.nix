{
  lib,
  pkgs,
  osConfig,
  ...
}:
lib.mkIf (!osConfig.capabilities.wallpaperEngine.enable) {
  systemd.user.services."swaybg" = {
    Service.ExecStart = "${lib.getExe pkgs.swaybg} -o * -i ${lib.custom.settings.non-server.background}";
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      After = [ "graphical-session.target" ];
    };
  };
}
