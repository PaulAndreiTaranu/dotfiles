return {
    {
        "neovim/nvim-lspconfig",

        event = { "BufReadPre", "BufNewFile" },

        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },

        config = function()
            -- Required setup by Mason
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { 'gopls' }
            })

            local lspconfig = require('lspconfig')
            local lsputil = require('lspconfig/util')
            lspconfig.gopls.setup({
                cmd = { 'gopls', 'serve' },
                filetypes = { 'go', 'gomod' },
                rootdir = lsputil.root_pattern({ 'go.work', 'go.mod', '.git' }),
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true
                        },
                        staticcheck = true
                    }
                }
            })
        end
    }

}