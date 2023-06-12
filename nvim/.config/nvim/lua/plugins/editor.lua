local Util = require("util")

return {

   -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {'nvim-lua/plenary.nvim'},
        opts = {
                defaults = {
                  mappings = {
                    i = {
                      ['<C-u>'] = false,
                      ['<C-d>'] = false,
                    },
                  },
                },
        },
        config = function()
              -- Enable telescope fzf native, if installed
              pcall(require('telescope').load_extension, 'fzf')
        end,
        keys = function()
              vim.keymap.set('n', '<leader>?', Util.telescope(oldfiles), { desc = '[?] Find recently opened files' })
              vim.keymap.set('n', '<leader><space>', Util.telescope(buffers), { desc = '[ ] Find existing buffers' })
              vim.keymap.set('n', '<leader>/', function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                Util.telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                  winblend = 10,
                  previewer = false,
                })
              end, { desc = '[/] Fuzzily search in current buffer' })
              
              vim.keymap.set('n', '<leader>gf', Util.telescope(git_files), { desc = 'Search [G]it [F]iles' })
              vim.keymap.set('n', '<leader>sf', Util.telescope(find_files), { desc = '[S]earch [F]iles' })
              vim.keymap.set('n', '<leader>sh', Util.telescope(help_tags), { desc = '[S]earch [H]elp' })
              vim.keymap.set('n', '<leader>sw', Util.telescope(grep_string), { desc = '[S]earch current [W]ord' })
              vim.keymap.set('n', '<leader>sg', Util.telescope(live_grep), { desc = '[S]earch by [G]rep' })
              vim.keymap.set('n', '<leader>sd', Util.telescope(diagnostics), { desc = '[S]earch [D]iagnostics' })

        end
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end
    },

}