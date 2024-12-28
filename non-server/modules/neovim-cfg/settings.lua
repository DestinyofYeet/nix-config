vim.g.mapleader = " "
local opt = vim.opt
opt.smarttab = true
opt.smartindent = true
opt.termguicolors = true
opt.guicursor = ""
opt.wildmenu = true
opt.wildmode = "list:longest"
-- opt.autoindent = true
opt.wrap = false
opt.number = true -- Show line numbers
opt.relativenumber = true
opt.signcolumn = "number"
opt.cursorline = true -- Highlight cursor line
opt.ignorecase = true -- Ignore case search
opt.smartcase = true -- Smart search
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 2 -- Number of spaces to use for each step of auto indent
opt.softtabstop = -1 -- Number of spaces that a <Tab> counts
opt.expandtab = true -- Use spaces instead of tab characters
opt.signcolumn = 'yes' -- Always draw the sign column even if there is no sign in it
opt.laststatus = 0 -- Disable status line
opt.undolevels = 100000 -- Maximum number of changes that can be undone.
opt.undofile = true -- Persist undo history to an undo file.
opt.scrolloff = 999

-- mappings
-- press t to focus tree
vim.keymap.set('n', 't', '<cmd>NvimTreeFocus<cr>')

-- press F2 to rename a variable
vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end)

-- clears the highlight
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<cr>")

-- Stay in Visual mode on indent
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', '<', '<gv')

-- Close braces etc
-- vim.keymap.set("i", "{", "{}<left>")
-- vim.keymap.set("i", "(", "()<left>")
-- vim.keymap.set("i", "'", "''<left>")
-- vim.keymap.set("i", '"', '""<left>')
-- vim.keymap.set("i", "{<Enter>", "{<Enter>}<Esc>O")

-- Use system clipboard
opt.clipboard = { 'unnamedplus', 'unnamed' }

-- config telescope
-- set keymaps
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fa', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- trouble
vim.keymap.set('n', '<leader>xx', function() require("trouble").open("diagnostics") end, {})

-- barbar
vim.keymap.set('n', '<leader>1', "<cmd>BufferGoto 1<cr>", {})
vim.keymap.set('n', '<leader>2', "<cmd>BufferGoto 2<cr>", {})
vim.keymap.set('n', '<leader>3', "<cmd>BufferGoto 3<cr>", {})
vim.keymap.set('n', '<leader>4', "<cmd>BufferGoto 4<cr>", {})
vim.keymap.set('n', '<leader>5', "<cmd>BufferGoto 5<cr>", {})
vim.keymap.set('n', '<leader>6', "<cmd>BufferGoto 6<cr>", {})
vim.keymap.set('n', '<leader>7', "<cmd>BufferGoto 7<cr>", {})
vim.keymap.set('n', '<leader>8', "<cmd>BufferGoto 8<cr>", {})
vim.keymap.set('n', '<leader>9', "<cmd>BufferGoto 9<cr>", {})

vim.keymap.set("n", "<leader>qb", "<cmd>BufferClose<cr>", {})

opt.mouse = ""
