{
  ...
}:{
  programs.neomutt = {
    enable = true;

    editor = "hx";
    vimKeys = true;
    sidebar = {
      enable = true;
    };

    checkStatsInterval = 60;

    binds = [
      # {
      #   action = "sidebar-next";
      #   key = "^l";
      #   map = [ "index" ];
      # }
      # {
      #   action = "sidebar-last";
      #   key = "^h";
      #   map = [ "index" ];
      # }

      {
        action = "group-chat-reply";
        key = "R";
        map = [ "index" ];
      }
    ];

    changeFolderWhenSourcingAccount = true;

    extraConfig = ''
      set sig_on_top = yes
    '';    
  };
}
