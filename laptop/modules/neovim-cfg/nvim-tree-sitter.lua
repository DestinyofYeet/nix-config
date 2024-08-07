local configs = require("nvim-treesitter.configs")
require("nvim-treesitter.install").prefer_git = true
configs.setup({
    prefer_git = true,
    ensure_installed = { "c", "vim", "rust", "lua" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },  
  })
require("nvim-treesitter.install").prefer_git = true
