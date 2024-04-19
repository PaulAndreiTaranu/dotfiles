-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"
-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 350
vim.opt.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menu,menuone,noinsert"

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--vim.opt.list = true
--vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Disable swap files.
vim.opt.swapfile = false

-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Number of spaces tabs count for
vim.opt.tabstop = 4
-- Insert indents automatically
vim.opt.smartindent = true
-- Size of an indent
vim.opt.shiftwidth = 4
