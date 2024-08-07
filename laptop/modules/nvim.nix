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

    extraConfig = builtins.readFile ./neovim-cfg/settings.lua;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile ./neovim-cfg/lualine.lua;
      }
      telescope-zf-native-nvim
      nvim-tree-lua
      nvim-web-devicons
      mason-nvim
      nvim-lspconfig
      nvim-cmp
      telescope-nvim
    ] ++ treesitter-parsers;
  };
}
