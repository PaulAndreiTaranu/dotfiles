return {
        {
            "nvim-treesitter/nvim-treesitter",
            version = false,
            build = ":TSInstallSync",
            event = { "BufReadPost", "BufNewFile" },
            dependencies = {
                { "nvim-treesitter/nvim-treesitter-textobjects" },
            },
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "c",
                        "cpp",
                        "comment",
                        "make",
                        "lua",
                        "python",
                        "vim",
                        "vimdoc",
                        "java",
                        "json",
                        "jsonc",
                        "toml",
                        "yaml",
                        "query",
                        "gitcommit",
                        "gitignore",
                        "regex",
                        "diff",
                        "bash",
                        "markdown",
                        "markdown_inline",
                        "latex",
                        "bibtex",
                        "rust",
                        "typescript",
                        "javascript",
                        "html",
                        "css",
                    },
                    highlight = {
                        enable = true,
                    },
                    indent = {
                        enable = true,
                        disable = { "python", "html" },
                    },
                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true,
                            keymaps = {
                                ['aa'] = '@parameter.outer',
                                ['ia'] = '@parameter.inner',
                                ['af'] = '@function.outer',
                                ['if'] = '@function.inner',
                                ['ac'] = '@class.outer',
                                ['ic'] = '@class.inner',
                            },
                        },
                        lsp_interop = {
                            enable = true,
                            border = "none",
                            floating_preview_opts = {},
                            peek_definition_code = {
                                ["<leader>pf"] = "@function.outer",
                                ["<leader>pc"] = "@class.outer",
                            },
                        },
                    },
                })
            end,
        },
    }