return {
	{
		"nvim-treesitter/nvim-treesitter",
        enabled = not vim.g.vscode,
		build = ":TSUpdate",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		event = {"VeryLazy"},
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "latex" },
					additional_vim_regex_highlighting = { "latex", "markdown" },
				},
				indent = { enable = true, disable = { "typst", "python" } },
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							--
							-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
							["]o"] = "@loop.*",
							-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
							--
							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
							["]a"] = "@parameter.inner",
							-- ["<C-f>"] = "@parameter.inner",
							["]e"] = "@return.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[a"] = "@parameter.inner",
							-- ["<C-b>"] = "@parameter.inner",
							["[e"] = "@return.inner",
							["M"] = { query = "@local.scope", query_group = "locals", desc = "Prev scope" },
						},
						goto_next_end = {
							["]]"] = "@class.outer",
						},
						goto_previous_end = {
							["[["] = "@class.outer",
						},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						goto_next = {
							["]c"] = "@conditional.outer",
							["]F"] = "@function.outer",
						},
						goto_previous = {
							["[c"] = "@conditional.outer",
							["[F"] = "@function.inner",
						},
					},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						-- init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "v",
						-- scope_incremental = "grc",
						node_decremental = "V",
					},
				},
			})
			-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			--          vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	lazy = true,
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		local tsc = require("treesitter-context")
	-- 		tsc.setup({
	-- 			enable = false,
	-- 			mode = "cursor",
	-- 			max_lines = 3,
	-- 		})
	--
	-- 		vim.g.toggle
	-- 			.new({
	-- 				name = "Treesitter Context",
	-- 				get = function()
	-- 					return tsc.enabled()
	-- 				end,
	-- 				set = function(state)
	-- 					if state then
	-- 						tsc.enable()
	-- 					else
	-- 						tsc.disable()
	-- 					end
	-- 				end,
	-- 			})
	-- 			:map("<leader>uC")
	-- 		-- vim.cmd("hi TreesitterContext gui=underline guisp=background")
	-- 		-- vim.cmd("hi TreesitterContextLineNumber guibg=background")
	-- 		-- vim.cmd("hi TreesitterContextSeparator gui=underline")
	-- 		-- vim.cmd("hi TreesitterContextBottom gui=underline")
	-- 		-- vim.cmd("hi clear TreesitterContextSeparator")
	-- 		-- vim.cmd("hi clear TreesitterContextBottom")
	-- 	end,
	-- },
}
