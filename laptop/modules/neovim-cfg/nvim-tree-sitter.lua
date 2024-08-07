local configs = require("nvim-treesitter.configs")
require("nvim-treesitter.install").prefer_git = true
configs.setup({
  ignore_install = "all", -- installs are managed by nixos

  highlight = {
    enable = true,
  },
})
require("nvim-treesitter.install").prefer_git = true
