return {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        keys = function()
              vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
              vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
              vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
              vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
              vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
        end
}