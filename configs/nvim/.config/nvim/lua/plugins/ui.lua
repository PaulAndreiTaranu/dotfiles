return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000, -- make sure to load this before all the other start plugins
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},

	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{
		"lukas-reineke/indent-blankline.nvim",
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
		main = "ibl",
	},
	{
		"nvim-lualine/lualine.nvim",

		event = "VeryLazy",

		dependencies = { "nvim-tree/nvim-web-devicons" },

		config = function()
			local p = require("rose-pine.palette")
			local bg_base = p.base

			local local_theme = {
				normal = {
					a = { bg = p.rose, fg = p.base, gui = "bold" },
					b = { bg = p.overlay, fg = p.rose, gui = "bold" },
					c = { bg = "NONE", fg = p.text },
				},
				insert = {
					a = { bg = p.foam, fg = p.base, gui = "bold" },
					b = { bg = p.overlay, fg = p.foam },
					c = { bg = "NONE", fg = p.text },
				},
				visual = {
					a = { bg = p.iris, fg = p.base, gui = "bold" },
					b = { bg = p.overlay, fg = p.iris },
					c = { bg = "NONE", fg = p.text },
				},
				replace = {
					a = { bg = p.pine, fg = p.base, gui = "bold" },
					b = { bg = p.overlay, fg = p.pine },
					c = { bg = "NONE", fg = p.text },
				},
				command = {
					a = { bg = p.love, fg = p.base, gui = "bold" },
					b = { bg = p.overlay, fg = p.love },
					c = { bg = "NONE", fg = p.text },
				},
				inactive = {
					a = { bg = bg_base, fg = p.muted, gui = "bold" },
					b = { bg = bg_base, fg = p.muted },
					c = { bg = bg_base, fg = p.muted },
				},
			}
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = local_theme,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "buffers" },
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
}
