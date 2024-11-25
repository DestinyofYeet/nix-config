{
  config,
  pkgs,
  ...
}:{
  programs.nushell = {
    enable = true;

    envFile.text = ''
    '';

    configFile.text = ''
      $env.EDITOR = 'hx'
      
      $env.config = {
        show_banner: false
      }

      use task.nu
    '';
  };

  home.activation = let
      source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/nushell/nu_scripts/refs/heads/main/modules/background_task/task.nu";
        sha256 = "1k94wifbbg78lplcrww6s2bmblknm5jxzyk26qca3w215g7q85d5";
      };

      scripts = import ./scripts.nix { inherit pkgs config; };
  in {
    write-task-file = ''
      ${scripts.update-needed-content-file}/bin/update-needed-content-file "${source}" "/home/ole/.config/nushell/scripts/task.nu"
    '';
  };
}
