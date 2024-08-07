{ pkgs, ... }: let
  treesitter-parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    c
    rust
    python
    vim
  ];

  mkPlugin = name: file : {
    plugin = name;
    type = "lua";
    config = builtins.readFile file;
  };

in {
  programs.neovim = {
    enable = true;

    extraLuaConfig = builtins.readFile ./neovim-cfg/settings.lua;

    plugins = with pkgs.vimPlugins; [
      (mkPlugin lualine-nvim ./neovim-cfg/lualine.lua)
      (mkPlugin nvim-cmp ./neovim-cfg/nvim-cmp.lua)
      (mkPlugin nvim-tree-lua ./neovim-cfg/nvim-tree.lua)
      telescope-zf-native-nvim
      nvim-web-devicons
      mason-nvim
      nvim-lspconfig
      telescope-nvim
      auto-pairs
      dressing-nvim
      luasnip
    ] ++ treesitter-parsers;
  };
}
