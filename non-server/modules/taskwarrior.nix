{
  pkgs,
  ...
}:{
  programs.taskwarrior = {
    enable = true;

    package = pkgs.taskwarrior3;

    dataLocation = "/home/ole/Nextcloud/Database/taskwarrior";
  };
}
