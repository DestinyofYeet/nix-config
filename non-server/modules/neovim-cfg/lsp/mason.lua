local mason = require("mason")
 -- import mason-lspconfig
local mason_lspconfig = require("mason-lspconfig")

-- enable mason and configure icons
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  -- list of servers for mason to install
  --ensure_installed = {
  --  "lua_ls",
  --  "rust_analyzer",
  --  "ast_grep",
  --  "clangd",
  --},
  ---- auto-install configured servers (with lspconfig)
  --automatic_installation = true, -- not the same as ensure_installed
})
