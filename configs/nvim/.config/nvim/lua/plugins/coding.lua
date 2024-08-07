return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { "python" }
		-- }
		-- ```
		opts = function()
			-- Colors
			-- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "red", fg = "NONE" })
			-- vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "blue" })
			-- vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "green", strikethrough = true })
			-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "orange", bold = true })
			-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "yellow", bold = true })
			-- vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "purple", italic = true })

			-- Config
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true
			return {
				auto_brackets = { "python" }, -- configure any filetype to auto add brackets
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				window = {
					completion = {
						scrollbar = false,
					},
				},
				snippet = {
					-- expand = function(args)
					-- 	require("luasnip").lsp_expand(args.body)
					-- end,
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),

				formatting = {
					format = function(entry, item)
						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				sorting = defaults.sorting,
			}
		end,
	},

	-- { -- Autocompletion
	-- 	"hrsh7th/nvim-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		-- Snippet Engine & its associated nvim-cmp source
	-- 		{
	-- 			"L3MON4D3/LuaSnip",
	-- 			build = (function()
	-- 				-- Build Step is needed for regex support in snippets.
	-- 				-- This step is not supported in many windows environments.
	-- 				-- Remove the below condition to re-enable on windows.
	-- 				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
	-- 					return
	-- 				end
	-- 				return "make install_jsregexp"
	-- 			end)(),
	-- 			dependencies = {
	-- 				-- `friendly-snippets` contains a variety of premade snippets.
	-- 				--    See the README about individual language/framework/plugin snippets:
	-- 				--    https://github.com/rafamadriz/friendly-snippets
	-- 				-- {
	-- 				--   'rafamadriz/friendly-snippets',
	-- 				--   config = function()
	-- 				--     require('luasnip.loaders.from_vscode').lazy_load()
	-- 				--   end,
	-- 				-- },
	-- 			},
	-- 		},
	-- 		"saadparwaiz1/cmp_luasnip",
	--
	-- 		-- Adds other completion capabilities.
	-- 		--  nvim-cmp does not ship with all sources by default. They are split
	-- 		--  into multiple repos for maintenance purposes.
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-path",
	-- 	},
	-- 	config = function()
	-- 		-- See `:help cmp`
	-- 		local cmp = require("cmp")
	-- 		local luasnip = require("luasnip")
	-- 		luasnip.config.setup({})
	--
	-- 		cmp.setup({
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			completion = { completeopt = "menu,menuone,noinsert" },
	--
	-- 			-- For an understanding of why these mappings were
	-- 			-- chosen, you will need to read `:help ins-completion`
	-- 			--
	-- 			-- No, but seriously. Please read `:help ins-completion`, it is really good!
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				-- Select the [n]ext item
	-- 				["<C-n>"] = cmp.mapping.select_next_item(),
	-- 				-- Select the [p]revious item
	-- 				["<C-p>"] = cmp.mapping.select_prev_item(),
	--
	-- 				-- Scroll the documentation window [b]ack / [f]orward
	-- 				["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
	--
	-- 				-- Accept ([y]es) the completion.
	-- 				--  This will auto-import if your LSP supports it.
	-- 				--  This will expand snippets if the LSP sent a snippet.
	-- 				["<C-y>"] = cmp.mapping.confirm({ select = true }),
	--
	-- 				-- If you prefer more traditional completion keymaps,
	-- 				-- you can uncomment the following lines
	-- 				--['<CR>'] = cmp.mapping.confirm { select = true },
	-- 				--['<Tab>'] = cmp.mapping.select_next_item(),
	-- 				--['<S-Tab>'] = cmp.mapping.select_prev_item(),
	--
	-- 				-- Manually trigger a completion from nvim-cmp.
	-- 				--  Generally you don't need this, because nvim-cmp will display
	-- 				--  completions whenever it has completion options available.
	-- 				["<C-Space>"] = cmp.mapping.complete({}),
	--
	-- 				-- Think of <c-l> as moving to the right of your snippet expansion.
	-- 				--  So if you have a snippet that's like:
	-- 				--  function $name($args)
	-- 				--    $body
	-- 				--  end
	-- 				--
	-- 				-- <c-l> will move you to the right of each of the expansion locations.
	-- 				-- <c-h> is similar, except moving you backwards.
	-- 				-- ["<C-l>"] = cmp.mapping(function()
	-- 				-- 	if luasnip.expand_or_locally_jumpable() then
	-- 				-- 		luasnip.expand_or_jump()
	-- 				-- 	end
	-- 				-- end, { "i", "s" }),
	-- 				-- ["<C-h>"] = cmp.mapping(function()
	-- 				-- 	if luasnip.locally_jumpable(-1) then
	-- 				-- 		luasnip.jump(-1)
	-- 				-- 	end
	-- 				-- end, { "i", "s" }),
	--
	-- 				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
	-- 				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	-- 			}),
	-- 			sources = {
	-- 				{ name = "nvim_lsp" },
	-- 				{ name = "luasnip" },
	-- 				{ name = "path" },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,

		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},

		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "beautysh" },
				-- Conform can also run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can use a sub-list to tell conform to run *until* a formatter is found.
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
			},

			formatters = {
				prettier = {
					prepend_args = {
						"--no-semi",
						"--tab-width",
						"4",
						"--print-width",
						"100",
						"--bracket-same-line",
						"--single-quote",
						"--jsx-single-quote",
						"--arrow-parens",
						"always",
						"--end-of-line",
						"lf",
						"--prose-wrap",
						"always",
					},
				},
			},
		},
	},
}
