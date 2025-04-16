-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set({ "i", "n" }, "<Esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Disable Space in normal for better Leader mapping
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save buffer" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save buffer" })
vim.keymap.set({ "x", "n", "s", "v" }, "<Leader>w", "<cmd>bd!<cr>", { desc = "Delete buffer" })
vim.keymap.set({ "x", "n", "s", "v" }, "<Leader>kw", "<cmd>wa<cr><cmd>%bd<cr>", { desc = "Delete buffer" })
vim.keymap.set({ "x", "n", "s", "v" }, "<C-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set({ "x", "n", "s", "v" }, "<C-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-b>", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Oil.nvim File Browser
-- vim.keymap.set("n", "<Leader>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<Leader>e", function()
    vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil --float")
end)

-- Quit
vim.keymap.set("n", "<Leader>z", "<cmd>qa!<cr>", { desc = "Quit all" })
