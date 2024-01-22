return {
    {
        'projekt0n/github-nvim-theme',

        lazy = false, -- make sure we load this during startup if it is your main colorscheme

        priority = 1000, -- make sure to load this before all the other start plugins

        config = function()
            vim.cmd('colorscheme github_dark_default')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',

        dependencies = { 'nvim-tree/nvim-web-devicons' },

        config = function()
            require('lualine').setup {
                options = {
                  icons_enabled = true,
                  theme = 'auto',
                  component_separators = { left = '', right = ''},
                  section_separators = { left = '', right = ''},
                  disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                  },
                  ignore_focus = {},
                  always_divide_middle = true,
                  globalstatus = false,
                  refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                  }
                },
                sections = {
                  lualine_a = {'mode'},
                  lualine_b = {'branch', 'diff', 'diagnostics'},
                  lualine_c = {'filename'},
                  lualine_x = {'encoding', 'fileformat', 'filetype'},
                  lualine_y = {'progress'},
                  lualine_z = {'location'}
                },
                inactive_sections = {
                  lualine_a = {},
                  lualine_b = {},
                  lualine_c = {'filename'},
                  lualine_x = {'location'},
                  lualine_y = {},
                  lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
              }
        end
    }
}