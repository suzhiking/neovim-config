local utils = require("utils")
return {
	-- Collection of various small independent plugins/modules
	"nvim-mini/mini.nvim",
	enabled = true,
	event = "VeryLazy",
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"Trouble",
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"notify",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
				"toggleterm",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "SnacksDashboardOpened",
			callback = function(data)
				vim.b[data.buf].miniindentscope_disable = true
			end,
		})
	end,
	config = function()
		-- Better icons support
		require("mini.icons").setup()

		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		local ai = require("mini.ai")
		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				e = { -- Word with case
					{
						"%u[%l%d]+%f[^%l%d]",
						"%f[%S][%l%d]+%f[^%l%d]",
						"%f[%P][%l%d]+%f[^%l%d]",
						"^[%l%d]+%f[^%l%d]",
					},
					"^().*()$",
				},
				-- i = utils.ai_indent, -- indent
				-- g = utils.ai_buffer, -- buffer
				u = ai.gen_spec.function_call(), -- u for "Usage"
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			},
		})

		require("mini.surround").setup({
			-- Number of lines within which surrounding is searched
			n_lines = 20,
		})
		vim.keymap.set("x", ")", "sa)", { remap = true })
		vim.keymap.set("x", "]", "sa]", { remap = true })
		vim.keymap.set("x", '"', 'sa"', { remap = true })
		vim.keymap.set("x", "'", "sa'", { remap = true })
		vim.keymap.set("x", "}", "sa}", { remap = true })
		vim.keymap.set("x", "$", "sa}", { remap = true })
		-- vim.keymap.set("v", ">", "sa>", { remap = true })
		-- vim.keymap.set("n", "s", "<Nop>", { silent = true })
		vim.keymap.set("n", "sa)", "saiw)", { remap = true })
		vim.keymap.set("n", "sa]", "saiw]", { remap = true })
		vim.keymap.set("n", 'sa"', 'saiw"', { remap = true })
		vim.keymap.set("n", "sa'", "saiw'", { remap = true })
		vim.keymap.set("n", "sa}", "saiw}", { remap = true })
		vim.keymap.set("n", "sa$", "saiw}", { remap = true })

		local operator = require("mini.operators")
		operator.setup({
			-- Each entry configures one operator.
			-- `prefix` defines keys mapped during `setup()`: in Normal mode
			-- to operate on textobject and line, in Visual - on selection.

			-- Evaluate text and replace with output
			evaluate = {
				prefix = "g=",

				-- Function which does the evaluation
				func = nil,
			},

			-- Exchange text regions
			exchange = {
				prefix = "gX",

				-- Whether to reindent new text to match previous indent
				reindent_linewise = true,
			},

			-- Multiply (duplicate) text
			multiply = {
				prefix = "gm",

				-- Function which can modify text before multiplying
				func = nil,
			},

			-- Replace text with register
			replace = {
				prefix = "R",

				-- Whether to reindent new text to match previous indent
				reindent_linewise = true,
			},

			-- Sort text
			sort = {
				prefix = "gs",

				-- Function which does the sort
				func = nil,
			},
		})

		-- require("mini.files").setup({
		-- 	mappings = {
		-- 		-- close = "<ESC>",
		-- 	},
		-- 	windows = {
		-- 		preview = true,
		-- 		width_focus = 30,
		-- 		width_preview = 30,
		-- 	},
		-- })
		-- vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "File explorer" })
		-- vim.keymap.set("n", "<leader>E", function()
		-- 	MiniFiles.open(vim.api.nvim_buf_get_name(0))
		-- end, { desc = "Current file explorer" })

		-- local show_dotfiles = true
		-- local filter_show = function(fs_entry)
		-- 	return true
		-- end
		-- local filter_hide = function(fs_entry)
		-- 	return not vim.startswith(fs_entry.name, ".")
		-- end
		--
		-- local toggle_dotfiles = function()
		-- 	show_dotfiles = not show_dotfiles
		-- 	local new_filter = show_dotfiles and filter_show or filter_hide
		-- 	require("mini.files").refresh({ content = { filter = new_filter } })
		-- end
		--
		-- local files_set_cwd = function()
		-- 	local cur_entry_path = MiniFiles.get_fs_entry().path
		-- 	local cur_directory = vim.fs.dirname(cur_entry_path)
		-- 	if cur_directory ~= nil then
		-- 		vim.fn.chdir(cur_directory)
		-- 	end
		-- end
		--
		-- -- extra mappings for mini.files
		-- vim.api.nvim_create_autocmd("User", {
		-- 	pattern = "MiniFilesBufferCreate",
		-- 	callback = function(args)
		-- 		local map_buf = function(lhs, rhs, desc)
		-- 			vim.keymap.set("n", lhs, rhs, { buffer = args.data.buf_id, desc = desc or "" })
		-- 		end
		--
		-- 		map_buf("<leader>e", MiniFiles.close)
		-- 		-- map_buf("<ESC>", MiniFiles.close)
		-- 		map_buf("<leader>s", MiniFiles.synchronize, "Synchronize")
		-- 		map_buf("<CR>", function()
		-- 			MiniFiles.go_in({ close_on_file = true })
		-- 		end, "Open file")
		-- 		map_buf("g.", toggle_dotfiles, "Toggle hidden files")
		-- 		map_buf("gc", files_set_cwd, "Set cwd")
		--
		-- 		-- Add extra mappings from *MiniFiles-examples*
		-- 	end,
		-- })

		require("mini.move").setup({
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				-- left = 'H',
				-- right = 'L',
				down = "J",
				up = "K",

				-- Move current line in Normal mode
				line_left = "<M-h>",
				line_right = "<M-l>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},

			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		})

		-- require("mini.pick").setup({
		-- 	-- Keys for performing actions. See `:h MiniPick-actions`.
		-- 	mappings = {
		-- 		move_down = "<C-j>",
		-- 		move_up = "<C-k>",
		-- 	},
		-- })
		-- vim.keymap.set("n", "<leader>fm", MiniPick.builtin.files, { desc = "Find files" })

		-- local statusline = require("mini.statusline")
		-- statusline.setup({
		-- 	use_icons = vim.g.have_nerd_font,
		-- 	-- set_vim_settings = false,
		-- })
		-- vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "#414559" })
		-- vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "#414559" })
		-- vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#292C3C", bg = "#292C3C" })
		--
		-- -- You can configure sections in the statusline by overriding their
		-- -- default behavior. For example, here we set the section for
		-- -- cursor location to LINE:COLUMN
		-- ---@diagnostic disable-next-line: duplicate-set-field
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end

		-- animated indentscope
		-- require("mini.indentscope").setup({
		-- 	symbol = "│",
		-- 	options = { try_as_border = true },
		-- })
	end,
}
