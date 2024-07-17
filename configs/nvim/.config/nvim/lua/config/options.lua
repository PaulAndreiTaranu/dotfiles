-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true -- Insert indents automatically

-- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.signcolumn = "no"

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
vim.opt.smoothscroll = true

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
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
