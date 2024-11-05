{
  ...
}:{
  programs.nushell = {
    enable = true;

    envFile.text = ''
    '';

    configFile.text = ''
      $env.config = {
        show_banner: false
      }

      alias ll = ls -l
      alias rebuild-system = sudo nixos-rebuild switch --flake /home/ole/nixos#
    '';
  };
}
