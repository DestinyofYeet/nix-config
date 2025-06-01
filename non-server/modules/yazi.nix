{ ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = { mgr = { show_hidden = true; }; };
  };
}
