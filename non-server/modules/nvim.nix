{ pkgs, ... }: let
  treesitter-parsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    c
    rust
    python
    vim
    lua
    vimdoc
    nix
  ];

  mkPlugin = name : file : {
    plugin = name;
    type = "lua";
    config = builtins.readFile file;
  };

in {
  programs.neovim = {
    enable = true;

    defaultEditor = false;

    extraLuaConfig = builtins.readFile ./neovim-cfg/settings.lua;

    extraPackages = with pkgs; [
      lua-language-server
      clang-tools
      ast-grep
      pyright
    ];

    plugins = with pkgs.vimPlugins; [
      (mkPlugin lualine-nvim ./neovim-cfg/lualine.lua)
      (mkPlugin nvim-cmp ./neovim-cfg/nvim-cmp.lua)
      (mkPlugin nvim-tree-lua ./neovim-cfg/nvim-tree.lua)
      (mkPlugin nvim-treesitter ./neovim-cfg/nvim-tree-sitter.lua)
      (mkPlugin mason-nvim ./neovim-cfg/lsp/mason.lua)
      (mkPlugin nvim-lspconfig ./neovim-cfg/lsp/lspconfig.lua)
      (mkPlugin trouble-nvim ./neovim-cfg/trouble.lua)
      (mkPlugin barbar-nvim ./neovim-cfg/barbar.lua)
      telescope-zf-native-nvim
      nvim-web-devicons
      mason-lspconfig-nvim
      telescope-nvim
      auto-pairs
      dressing-nvim
      luasnip
      cmp-nvim-lsp
    ] ++ treesitter-parsers;
  };
}
