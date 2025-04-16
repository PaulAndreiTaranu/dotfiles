return {
    -- Color Theme
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000, -- make sure to load this before all the other start plugins
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        config = function()
            require('kanagawa').setup({
                compile = false,  -- enable compiling the colorscheme
                undercurl = true, -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = { bold = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = true,    -- do not set background color
                dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
                terminalColors = true, -- define vim.g.terminal_color_{0,17}
                colors = {             -- add/modify theme and palette colors
                    palette = {},
                    theme = {
                        wave = {},
                        lotus = {},
                        dragon = {},
                        all = {
                            ui = {
                                bg_gutter = "none"
                            }
                        }
                    },
                },
                overrides = function(colors) -- add/modify highlights
                    local theme = colors.theme

                    return {
                        ["@comment"] = { fg = 'white', italic = true },
                        ["@property"] = { bold = true },
                        ["@variable"] = { bold = true },

                        Normal = { bg = "none" },
                        NormalFloat = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        FloatTitle = { bg = "none" },

                        -- -- Save an hlgroup with dark background and dimmed foreground
                        -- -- so that you can use it where your still want darker windows.
                        -- -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        -- NormalDark = { fg = 'red', bg = 'red' },

                        -- -- Popular plugins that open floats will link to NormalFloat by default;
                        -- -- set their background accordingly if you wish to keep them dark and borderless
                        -- LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        -- MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    }
                end,
            })

            -- setup must be called before loading
            vim.cmd("colorscheme kanagawa-wave")
        end,
    },


    -- Status Line
    -- {
    --     'echasnovski/mini.statusline',
    --     version = false,
    --     event = "VeryLazy",
    --     dependencies = { 'echasnovski/mini.icons' },
    --     opts = {}
    -- },
    {
        "nvim-lualine/lualine.nvim",

        event = "VeryLazy",

        dependencies = { 'echasnovski/mini.icons' },

        config = function()
            local theme = require("kanagawa.colors").setup().theme
            local palette = require("kanagawa.colors").setup().palette

            local local_theme = {}

            local_theme.normal = {
                a = { bg = palette['roninYellow'] },
                b = { bg = palette['peachRed'], fg = palette['sumiInk0'] },
                c = {}
            }

            local_theme.insert = {
                a = { bg = palette['springGreen'] },
                b = { bg = palette['sumiInk0'], fg = palette['waveRed'] },
                c = {}
            }

            local_theme.command = {
                a = { bg = palette['springBlue'] },
                b = { bg = palette['sumiInk0'], fg = palette['waveRed'] },
                c = {}
            }

            local_theme.visual = {
                a = { bg = palette['oniViolet'] },
                b = { bg = palette['sumiInk0'], fg = palette['waveRed'] },
                c = {}
            }

            local_theme.replace = {
                a = { bg = palette['dragonBlue'] },
                b = { bg = palette['sumiInk0'], fg = palette['waveRed'] },
                c = {}
            }

            local_theme.inactive = {
                a = { bg = palette['roninYellow'] },
                b = { bg = palette['sumiInk0'], fg = palette['waveRed'] },
                c = {}
            }

            for _, mode in pairs(local_theme) do
                for _, section in pairs(mode) do
                    section.gui = 'bold'
                end

                mode.a.fg = palette['sumiInk0']
                mode.c.bg = palette['sumiInk0']
                mode.c.fg = palette['sumiInk0']
            end

            require("lualine").setup({
                options = {
                    icons_enabled = 'auto',
                    theme = local_theme,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },

                    ignore_focus = {},
                    globalstatus = true,
                    refresh = {
                        statusline = 80,
                        tabline = 100,
                        winbar = 100,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { 'buffers', },
                    lualine_c = {},
                    lualine_x = { "diagnostics" },
                    lualine_y = { "diff", "branch" },
                    lualine_z = { "encoding", "filetype" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { "lazy", "mason", "oil" },
            })
        end,

    },

    -- Icons
    {
        'echasnovski/mini.icons',
        version = false,
        opts = {}
    },

    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    -- Indent line
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
    },


}
