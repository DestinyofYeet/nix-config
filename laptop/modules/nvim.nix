{ pkgs, ... }: let
  treesitter-parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    c
    rust
    python
    vim
  ];
in {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      telescope-zf-native-nvim
      nvim-tree-lua
      nvim-web-devicons
      mason-nvim
      nvim-lspconfig
      nvim-cmp
    ] ++ treesitter-parsers;
  };
}
