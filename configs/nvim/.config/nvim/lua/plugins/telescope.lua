return {
    'nvim-telescope/telescope.nvim',

    branch = '0.1.x',

    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
            return vim.fn.executable 'make' == 1
            end,
        },
    },
    
    config = function()
        local telescope = require('telescope')
        local telebuiltin = require('telescope.builtin')

        telescope.setup({
            defaults = {
                hidden = true,
                initial_mode = 'normal',
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
                vimgrep_arguments = {
                    "rg",
                    "-L",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                  },
                  prompt_prefix = "   ",
                  selection_caret = "  ",
                  entry_prefix = "  ",
                  selection_strategy = "reset",
                  sorting_strategy = "ascending",
                  layout_strategy = "horizontal",
                  layout_config = {
                    horizontal = {
                      prompt_position = "top",
                      preview_width = 0.55,
                      results_width = 0.8,
                    },
                    vertical = {
                      mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                  },
                  file_sorter = require("telescope.sorters").get_fuzzy_file,
                  file_ignore_patterns = { "node_modules", ".git" },
                  generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                  path_display = { "truncate" },
                  winblend = 0,
                  border = {},
                  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                  color_devicons = true,
                  set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                  file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                  grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                  qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                  -- Developer configurations: Not meant for general override
                  buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            },
            pickers = {
                find_files = {
                    hidden = true
                }
            },
            extensions = {
                file_browser = {
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    hidden = true,
                },
            },
        })
        
        -- Enable telescope fzf native, if installed
        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'file_browser')

        -- Telescope live_grep in git root
        -- Function to find the git root directory based on the current buffer's path
        local function find_git_root()
            -- Use the current buffer's path as the starting point for the git search
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir
            local cwd = vim.fn.getcwd()
            -- If the buffer is not associated with a file, return nil
            if current_file == '' then
            current_dir = cwd
            else
            -- Extract the directory from the current file's path
            current_dir = vim.fn.fnamemodify(current_file, ':h')
            end
        
            -- Find the Git root directory from the current file's path
            local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
            if vim.v.shell_error ~= 0 then
            print 'Not a git repository. Searching on current working directory'
            return cwd
            end
            return git_root
        end
        
        -- Custom live_grep function to search in git root
        local function live_grep_git_root()
            local git_root = find_git_root()
            if git_root then
                telebuiltin.live_grep({ search_dirs = { git_root } })
            end
        end
        vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

        local function telescope_live_grep_open_files()
            telebuiltin.live_grep({
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            })
        end
        
        
        vim.keymap.set('n', '<leader>?', telebuiltin.oldfiles)
        vim.keymap.set('n', '<leader><space>', telebuiltin.buffers)
        vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files)
        vim.keymap.set('n', '<leader>ss', telebuiltin.builtin)
        vim.keymap.set('n', '<leader>gf', telebuiltin.git_files)
        vim.keymap.set('n', '<leader>f', telebuiltin.find_files)
        vim.keymap.set('n', '<leader>sh', telebuiltin.help_tags)
        vim.keymap.set('n', '<leader>sw', telebuiltin.grep_string)
        vim.keymap.set('n', '<leader>sg', telebuiltin.live_grep)
        vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>')
        vim.keymap.set('n', '<leader>sd', telebuiltin.diagnostics)
        vim.keymap.set('n', '<leader>sr', telebuiltin.resume)
        vim.keymap.set('n', '<leader>e', telescope.extensions.file_browser.file_browser)

        vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            telebuiltin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })
    end,
}
