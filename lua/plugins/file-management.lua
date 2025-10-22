return {
	{ -- file bookmarks
		"otavioschwanck/arrow.nvim",
		enabled = false,
		lazy = true,
		event = "VeryLazy",
		keys = {
			{ "[m", "<cmd>Arrow prev_buffer_bookmark<cr>", desc = "Goto previous buffer bookmark" },
			{ "]m", "<cmd>Arrow next_buffer_bookmark<cr>", desc = "Goto next buffer bookmark" },
		},
		opts = {
			show_icons = true,
			leader_key = ",", -- Recommended to be a single key
			index_keys = "1234qweradfzxcv56789bnmZXVBNM,ghjklAFGHJKLtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
			buffer_leader_key = "<c-m>", -- Per Buffer Mappings
			mappings = {
				edit = "E",
				delete_mode = "d",
				clear_all_items = "C",
				toggle = "s", -- used as save if separate_save_and_remove is true
				open_vertical = "|",
				open_horizontal = "-",
				quit = "Esc",
				remove = "x", -- only used if separate_save_and_remove is true
				next_item = "]",
				prev_item = "[",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = true,
		optional = true,
		enabled = false,
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,
		keys = {
			{
				"<leader>uE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
				end,
				desc = "Toggle explorer (cb)",
				remap = true,
			},
			{
				"<leader>ue",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "NeoTree",
				remap = true,
			},
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git explorer",
			},
			-- {
			--   "<leader>bb",
			--   function()
			--     require("neo-tree.command").execute({ source = "buffers", toggle = true })
			--   end,
			--   desc = "Buffer explorer",
			-- },
		},
		config = function()
			local utils = require("utils")
			local get_icon = utils.get_icon
			require("neo-tree").setup({
				close_if_last_window = true,
				auto_clean_after_session_restore = true,
				sources = { "filesystem", "buffers", "git_status" },
				source_selector = {
					winbar = true,
					content_layout = "center",
					sources = {
						{ source = "filesystem", display_name = get_icon("FolderClosed", 1, true) .. "File" },
						{ source = "buffers", display_name = get_icon("DefaultFile", 1, true) .. "Bufs" },
						{ source = "git_status", display_name = get_icon("Git", 1, true) .. "Git" },
						{ source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
					},
				},
				default_component_configs = {
					indent = { padding = 0 },
					icon = {
						folder_closed = get_icon("FolderClosed"),
						folder_open = get_icon("FolderOpen"),
						folder_empty = get_icon("FolderEmpty"),
						folder_empty_open = get_icon("FolderEmpty"),
						default = get_icon("DefaultFile"),
					},
					modified = { symbol = get_icon("FileModified") },
					git_status = {
						symbols = {
							added = get_icon("GitAdd"),
							deleted = get_icon("GitDelete"),
							modified = get_icon("GitChange"),
							renamed = get_icon("GitRenamed"),
							untracked = get_icon("GitUntracked"),
							ignored = get_icon("GitIgnored"),
							unstaged = get_icon("GitUnstaged"),
							staged = get_icon("GitStaged"),
							conflict = get_icon("GitConflict"),
						},
					},
				},
				commands = {
					parent_or_close = function(state)
						local node = state.tree:get_node()
						if (node.type == "directory" or node:has_children()) and node:is_expanded() then
							state.commands.toggle_node(state)
						else
							require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
						end
					end,
					child_or_open = function(state)
						local node = state.tree:get_node()
						if node.type == "directory" or node:has_children() then
							if not node:is_expanded() then -- if unexpanded, expand
								state.commands.toggle_node(state)
							else -- if expanded and has children, seleect the next child
								require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
							end
						else -- if not a directory just open it
							state.commands.open(state)
						end
					end,
					copy_selector = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local filename = node.name
						local modify = vim.fn.fnamemodify

						local vals = {
							["BASENAME"] = modify(filename, ":r"),
							["EXTENSION"] = modify(filename, ":e"),
							["FILENAME"] = filename,
							["PATH (CWD)"] = modify(filepath, ":."),
							["PATH (HOME)"] = modify(filepath, ":~"),
							["PATH"] = filepath,
							["URI"] = vim.uri_from_fname(filepath),
						}

						local options = vim.tbl_filter(function(val)
							return vals[val] ~= ""
						end, vim.tbl_keys(vals))
						if vim.tbl_isempty(options) then
							return
						end
						table.sort(options)
						vim.ui.select(options, {
							prompt = "Choose to copy to clipboard:",
							format_item = function(item)
								return ("%s: %s"):format(item, vals[item])
							end,
						}, function(choice)
							local result = vals[choice]
							if result then
								utils.notify(("Copied: `%s`"):format(result))
								vim.fn.setreg("+", result)
							end
						end)
					end,
					find_in_dir = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						require("telescope.builtin").find_files({
							cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
						})
					end,
				},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = "none",
						["Y"] = {
							function(state)
								local node = state.tree:get_node()
								local path = node:get_id()
								vim.fn.setreg("+", path, "c")
							end,
							desc = "copy path to clipboard",
						},
						["[b"] = "prev_source",
						["]b"] = "next_source",
						-- F = require("utils").is_available("telescope.nvim") and "find_in_dir" or nil,
						h = "parent_or_close",
						l = "child_or_open",
						o = "open",
					},
					fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
						["<C-j>"] = "move_cursor_down",
						["<C-k>"] = "move_cursor_up",
					},
				},
				filesystem = {
					follow_current_file = { enabled = true },
					hijack_netrw_behavior = "open_current",
					use_libuv_file_watcher = vim.fn.has("win32") ~= 1,
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		lazy = false,
        enabled = false,
		opts = {},
		keys = {
			{
				"<space>.",
				function()
					require("oil").open()
				end,
				desc = "Oil File Manager",
			},
		},
		-- Optional dependencies
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	},
}
