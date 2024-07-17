return {
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	{ -- File browser
		"echasnovski/mini.files",
		version = false,
		lazy = false,
		init = function()
			-- Add rounded corners.
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesWindowOpen",
				callback = function(args)
					local win_id = args.data.win_id
					vim.api.nvim_win_set_config(win_id, { border = "rounded" })
				end,
			})
			-- Use `vim.schedule_wrap()` to allow temporary "fast" window chang
			local minifiles_track_lost_focus = vim.schedule_wrap(function()
				local ft = vim.bo.filetype
				if ft == "minifiles" or ft == "minifiles-help" then
					return
				end
				local cur_win_id = vim.api.nvim_get_current_win()
				require("mini.files").close()
				pcall(vim.api.nvim_set_current_win, cur_win_id)
			end)

			vim.api.nvim_create_autocmd(
				"BufEnter",
				{ callback = minifiles_track_lost_focus, desc = "Close 'mini.files' on lost focus" }
			)
		end,
		opts = {
			options = {
				use_as_default_explorer = true,
			},
			mappings = {
				go_in = "l",
				go_in_plus = "<C-l>",
				go_out = "h",
				go_out_plus = "<C-h>",
				synchronize = "<C-s>",
			},
		},

		config = function(_, opts)
			local MiniFiles = require("mini.files")
			MiniFiles.setup(opts)

			local open_current_file_dir = function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
			end

			local open_cwd = function()
				MiniFiles.open(vim.uv.cwd(), true)
			end

			vim.keymap.set("n", "<leader>E", open_current_file_dir)
			vim.keymap.set("n", "<leader>e", open_cwd)
		end,
	},
	-- { -- File Browser
	-- 	"stevearc/oil.nvim",
	-- 	opts = {},
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("oil").setup({
	-- 			default_file_explorer = true,
	-- 			skip_confirm_for_simple_edits = true,
	-- 			view_options = {
	-- 				show_hidden = true,
	-- 				natural_order = true,
	-- 				is_always_hidden = function(name, _)
	-- 					return name == ".." or name == ".git"
	-- 				end,
	-- 			},
	-- 			float = {
	-- 				padding = 2,
	-- 				max_width = 90,
	-- 				max_height = 0,
	-- 			},
	-- 			win_options = {
	-- 				wrap = true,
	-- 				winblend = 0,
	-- 			},
	-- 			keymaps = {
	-- 				["<C-c>"] = false,
	-- 				["<C-s>"] = false,
	-- 				["<C-h>"] = false,
	-- 				["<C-l>"] = false,
	-- 				["<C-k>"] = false,
	-- 				["<C-j>"] = false,
	-- 				["h"] = "actions.parent",
	-- 				["l"] = "actions.select",
	-- 				["<leader>E"] = "actions.open_cwd",
	-- 				["q"] = "actions.close",
	-- 			},
	-- 		})
	-- 		-- vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	-- 		vim.keymap.set("n", "<leader>e", function()
	-- 			vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil --float")
	-- 		end)
	-- 	end,
	-- },

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",

		build = ":TSUpdate",

		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"dockerfile",
				"go",
			},

			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},

		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
}
