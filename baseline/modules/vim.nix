{ ... }: {

  programs.vim = {
    enable = true;
    extraConfig = ''
      set tabstop=2
      set number
      xnoremap > >gv
      xnoremap < <gv
      '';
  };
}
