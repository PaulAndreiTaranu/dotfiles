return {
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		event = "VeryLazy",
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
				reset = "r",
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

	-- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",

		version = false, -- last release is way too old and doesn't work on Windows

		build = ":TSUpdate",

		event = { "LazyFile", "VeryLazy" },

		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline

		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,

		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

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
				"printf",
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
				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				-- disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 200 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
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
