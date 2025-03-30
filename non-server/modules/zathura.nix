{ ... }: {
  programs.zathura = {
    enable = true;

    options = {
      "selection-clipboard" = "clipboard"; # uses system clipboard
    };
  };
}
