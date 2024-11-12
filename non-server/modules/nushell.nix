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
    '';
  };
}
