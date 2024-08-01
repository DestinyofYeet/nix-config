{ ... }:{

  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
    };

    syntaxHighlighting.enable = true;
  }
}
