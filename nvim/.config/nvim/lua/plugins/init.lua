return { 
    -- NOTE: First, some plugins that don't require any configuration
    -- Git related plugins
    'tpope/vim-fugitive', 'tpope/vim-rhubarb', -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth', -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = { -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp', -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets'}
    }, -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        opts = {}
    }, 
    {
        -- Adds git releated signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = {
                    text = '+'
                },
                change = {
                    text = '~'
                },
                delete = {
                    text = '_'
                },
                topdelete = {
                    text = '‾'
                },
                changedelete = {
                    text = '~'
                }
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, {
                    buffer = bufnr,
                    desc = 'Go to Previous Hunk'
                })
                vim.keymap.set('n', ']c', require('gitsigns').next_hunk, {
                    buffer = bufnr,
                    desc = 'Go to Next Hunk'
                })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, {
                    buffer = bufnr,
                    desc = '[P]review [H]unk'
                })
            end
        }
    }, -- "gc" to comment visual regions/lines
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
}
