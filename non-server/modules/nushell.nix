{
  config,
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

      alias ll = ls -l
      alias l = ls

      alias rebuild-system = sudo nixos-rebuild switch --flake /home/ole/nixos#
      
      alias yz = yazi

      alias kssh = kitten ssh

      source ${config.nuScripts.deploy-node}
    '';
  };
}
