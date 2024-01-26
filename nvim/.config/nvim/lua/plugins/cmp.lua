return {
    {
        'hrsh7th/nvim-cmp',
        
        version = false,

        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/vim-vsnip',
        },
        
        opts = function()
            local cmp = require('cmp')
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                      },
                      ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                          cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                          luasnip.expand_or_jump()
                        else
                          fallback()
                        end
                      end, { 'i', 's' }),
                      ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                          cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                          luasnip.jump(-1)
                        else
                          fallback()
                        end
                      end, { 'i', 's' }),
                }),

                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp', keyword_length = 3 },
                        { name = 'nvim-lsp_signature_help'},
                        { name = 'nvim_lua', keyword_length = 2 },
                        { name = 'vsnip', keyword_length = 2 },
                        { name = 'path'},
                        { name = 'vim_vsnip'},
                    }, {
                        { name = 'buffer', keyword_length = 2 },
                    }
                ),
            }
        end,

        config = function(_, opts)
            for _, source in ipairs(opts.sources) do
                source.group_index = source.group_index or 1
            end
            require('cmp').setup(opts)
        end,
    }
}