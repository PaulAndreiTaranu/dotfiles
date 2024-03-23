return {
    {
        'projekt0n/github-nvim-theme',

        lazy = false, -- make sure we load this during startup if it is your main colorscheme

        priority = 1000, -- make sure to load this before all the other start plugins

        config = function()
            vim.cmd('colorscheme github_dark_high_contrast')
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim", 

        main = "ibl",

        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            
            local hooks = require "ibl.hooks"
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            
            require("ibl").setup { indent = { highlight = highlight } }
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
                  lualine_b = {'filename'},
                  lualine_c = {'branch', 'diff', 'diagnostics'},
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