-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set({ "i", "n" }, "<Esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Disable Space in normal for better leader mapping
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Buffers
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save buffer" })
vim.keymap.set({ "x", "n", "s", "v" }, "<leader>w", "<cmd>bdelete!<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<C-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<C-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-b>", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Quit
vim.keymap.set("n", "<leader>z", "<cmd>qa!<cr>", { desc = "Quit all" })
