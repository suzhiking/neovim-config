return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
        optional = true,
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		cmd = "Telescope",
		keys = {
			-- Use mini-pick or fzf-lua as backup when number of files is large
			-- {
			-- 	"<leader><leader>",
			-- 	function()
			-- 		require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
			--                      winblend = 5,
			--                  }))
			-- 	end,
			-- 	desc = "Find files",
			-- },
			{
				"<leader>fw",
				function()
					require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({}))
				end,
				desc = "Live grep",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags(
						require("telescope.themes").get_ivy({ cache_picker = false })
					)
				end,
				desc = "Help",
			},
			{
				"<leader>fk",
				function()
					require("telescope.builtin").keymaps(require("telescope.themes").get_ivy({ cache_picker = false }))
				end,
				desc = "Keymaps",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").builtin(require("telescope.themes").get_ivy({ cache_picker = false }))
				end,
				desc = "Select",
			},
			{
				"<leader>fH",
				function()
					require("telescope.builtin").highlights(
						require("telescope.themes").get_ivy({ cache_picker = false })
					)
				end,
				desc = "Highlight",
			},
			{
				"<leader>fC",
				function()
					require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({}))
				end,
				desc = "Current word",
			},
			{
				"<leader>fd",
				function()
					return require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy({}))
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>l",
				function()
					return require("telescope.builtin").resume()
				end,
				desc = "Resume last search",
			},
			{
				"<leader>f.",
				function()
					return require("telescope.builtin").oldfiles(
						require("telescope.themes").get_ivy({ cache_picker = false })
					)
				end,
				desc = "Recent files",
			},
			-- { "<leader>b", "<cmd>Telescope buffers sort_mru=true sort_lastused=true previewer=false<cr>", desc = "Existing buffers", silent = true },
			{
				"<leader>b",
				function()
					require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				desc = "Existing buffers",
				silent = true,
			},
			{ "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options", silent = true },
			{
				"<leader>ff",
				function()
					return require("telescope.builtin").lsp_document_symbols(
						require("telescope.themes").get_ivy({ symbols = { "function", "method" } })
					)
				end,
				desc = "Methods",
			},
			{
				"<leader>fs",
				function()
					return require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_ivy({
						symbols = { "struct", "class", "typeparameter", "enum" },
					}))
				end,
				desc = "Structs",
			},

			{
				"<leader>fc",
				function()
					return require("telescope.builtin").lsp_document_symbols(
						require("telescope.themes").get_ivy({ symbols = { "constant" } })
					)
				end,
				desc = "Constants",
			},

			{
				"<leader>m",
				function()
					return require("telescope.builtin").marks(require("telescope.themes").get_dropdown({
						-- attach_mappings = function(prompt_bufnr, map)
						-- 	-- Bind normal-mode keys to jump to marks
						-- 	for char = 97, 123 do -- a-z ASCII range
						-- 		local key = string.char(char)
						-- 		map("n", key, function()
						--                               require("telescope.actions").close(prompt_bufnr)
						--                               vim.cmd("normal! '" .. key)
						-- 		end)
						-- 	end
						--
						-- 	return true
						-- end,
						winblend = 10,
						mark_type = "local",
						previewer = true,
						path_display = "hidden",
						initial_mode = "normal",
						cache_picker = false,
					}))
				end,
				desc = "Marks",
			},
			{
				"<leader>fR",
				function()
					return require("telescope.builtin").registers(
						require("telescope.themes").get_dropdown({ cache_picker = false })
					)
				end,
				desc = "Registers",
			},
			{
				"<leader>fq",
				function()
					return require("telescope.builtin").quickfix(require("telescope.themes").get_dropdown({}))
				end,
				desc = "Quickfix",
			},

			-- Change colorschemes
			{
				"<leader>uT",
				function()
					return require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown({
						cache_picker = false,
						winblend = 10,
						previwer = false,
					}))
				end,
				desc = "Find colorschemes",
			},
			-- Slightly advanced example of overriding default behavior and theme
			{
				"<leader>/",
				function()
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = true,
					}))
				end,
				desc = "Fuzzily search",
			},

			-- Shortcut for searching your neovim configuration files
			{
				"<leader>fn",
				function()
					require("telescope.builtin").find_files(
						require("telescope.themes").get_dropdown({
							cwd = vim.fn.stdpath("config"),
							cache_picker = false,
						})
					)
				end,
				desc = "NeoVim files",
			},
			-- Search for plugin source code
			{
				"<leader>fp",
				function()
					require("telescope.builtin").find_files(require("telescope.themes").get_ivy({
						cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
						cache_picker = false,
					}))
				end,
				desc = "Plugin files",
			},
			{
				"<leader>fp",
				function()
					require("config.telescope.mutligrep").live_multigrep(require("telescope.themes").get_ivy({}))
				end,
				desc = "Plugin files",
			},
			-- Need extension for undo history
			-- { "<leader>fu", function() require("telescope.builtin").undo { cache_picker = false } end, desc = "Undo history", silent = true },
		},
		config = function()
			local actions = require("telescope.actions")
			local get_icon = require("utils").get_icon
			require("telescope").setup({
				pickers = {
					colorscheme = { enable_preview = true },
					find_files = {
						find_command = { "rg", "--files", "--sortr=modified" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				defaults = {
					git_worktrees = vim.g.git_worktrees,
					prompt_prefix = get_icon("Selected", 1, true),
					selection_caret = get_icon("Selected", 1, true),
					path_display = { "smart" },
					sorting_strategy = "ascending",
					-- layout_strategy = "bottom_pane",
					layout_config = {
						horizontal = { prompt_position = "top", preview_width = 0.55 },
						vertical = { mirror = false },
						-- width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-l>"] = actions.cycle_history_next,
							["<C-h>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-t>"] = require("trouble.sources.telescope").open,
							["<RightMouse>"] = actions.close,
							["<LeftMouse>"] = actions.select_default,
							["<ScrollWheelDown>"] = actions.move_selection_next,
							["<ScrollWheelUp>"] = actions.move_selection_previous,
						},
						n = {
							q = actions.close,
							["<C-j>"] = actions.results_scrolling_up,
							["<C-k>"] = actions.results_scrolling_down,
							["<C-t>"] = require("trouble.sources.telescope").open,
							["<RightMouse>"] = actions.close,
							["<LeftMouse>"] = actions.select_default,
							-- ["<ScrollWheelDown>"] = actions.move_selection_next,
							-- ["<ScrollWheelUp>"] = actions.move_selection_previous,
						},
					},
					file_ignore_patterns = { "compile_commands.json", "lazy-lock.json" },
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
                        "-u"
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "undo")
		end,
	},
	{ -- TODO: replace telescope with fzf-lua
		"ibhagwan/fzf-lua",
        optional = true,
		enabled = false,
		keys = {
			{
				"<leader><leader>",
				function()
					require("fzf-lua").files({ header = false })
				end,
				desc = "Find files",
			},
		},
		opts = {
            files = {
                git_icons = false,
            },
			previewers = { builtin = { toggle_behavior = "extend" } },
			fzf_opts = { ["--layout"] = "reverse", ["--marker"] = "+" },
			header = false,
			winopts = {
				height = 25,
				width = 1,
				row = 1,
				backdrop = false,
				preview = {
					scrollbar = false,
					hidden = "nohidden",
					layout = "flex",
					horizontal = "right:50%",
					flip_columns = 120,
					cursorline = false,
				},
			},
			hls = {
				normal = "NormalFloat",
				border = "FloatBorder",
				title = "FloatBorder",
				help_normal = "Normal",
				help_border = "FloatBorder",
				preview_normal = "Normal",
				preview_border = "FloatBorder",
				preview_title = "FloatBorder",
				cursor = "Normal",
				search = "None",
			},
			fzf_colors = {
				["fg"] = { "fg", "CursorLine" },
				["bg"] = { "bg", "Normal" },
				["hl"] = { "fg", "FloatBorder" },
				["fg+"] = { "fg", "Normal" },
				["bg+"] = { "bg", "CursorLine" },
				["hl+"] = { "fg", "FloatBorder" },
				["info"] = { "fg", "Normal" },
				["prompt"] = { "fg", "FloatBorder" },
				["pointer"] = { "fg", "FloatBorder" },
				["marker"] = { "fg", "FloatBorder" },
				["spinner"] = { "fg", "Label" },
				["header"] = { "fg", "Comment" },
				["gutter"] = { "bg", "Normal" },
			},
		},
	},
}
