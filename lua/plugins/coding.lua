-- local get_icon = require("utils").get_icon

return {
	{
		"xeluxee/competitest.nvim",
		lazy = true,
		enabled = false,
		ft = { "cpp" },
		dependencies = "MunifTanjim/nui.nvim",
		config = function()
			require("competitest").setup({
				compile_command = {
					cpp = { exec = "g++-14", args = { "-std=c++23", "-O2", "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
				},
				-- runner_ui = { interface = "split" },
			})
			vim.keymap.set("n", "<leader>rr", "<cmd>CompetiTest run<cr>", { desc = "Rerun" })
			vim.keymap.set("n", "<leader>rt", "<cmd>CompetiTest receive testcases<cr>", { desc = "Receive testcases" })
			vim.keymap.set("n", "<leader>ru", "<cmd>CompetiTest show_ui<cr>", { desc = "Show UI" })
		end,
	},
	{

		"folke/flash.nvim",
        enabled = true,
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					jump_labels = true,
					label = { exclude = "hjkliardcxKb" },
					-- keys = { "f", "F", ";", "," },
				},
			},
			label = {
				exclude = "xKb",
			},
		},
        -- stylua: ignore
        keys = {
            -- { "s",     mode = { "n", "x", "o" }, ";",              {desc = "Flash", noremap = true, silent = true} },
            -- {"<leader>;", mode = {"n"}, ";", {noremap = false, silent = true }},
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
	},
	{
		"MagicDuck/grug-far.nvim",
        enabled = true,
		cmd = "GrugFar",
		keys = {
			{
				"<leader>fr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
		opts = function()
			return {
				headerMaxWidth = 80,
				keymaps = {
					close = { n = "q" },
				},
			}
		end,
	},
	{
		"danymat/neogen",
		enabled = true,
		lazy = true,
		keys = {
			{
				"<leader>ag",
				":Neogen<cr>",
				desc = "Generate annotations",
				silent = true,
			},
		},
		config = true,
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*"
	},
	{
		"kevinhwang91/nvim-bqf",
        enabled = true,
		ft = "qf",
		config = true,
	},
	{
		"jake-stewart/multicursor.nvim",
		enabled = false,
		config = function()
			local mc = require("multicursor-nvim")

			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<up>", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "x" }, "<down>", function()
				mc.lineAddCursor(1)
			end)
			set({ "n", "x" }, "<leader><up>", function()
				mc.lineSkipCursor(-1)
			end)
			set({ "n", "x" }, "<leader><down>", function()
				mc.lineSkipCursor(1)
			end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<leader>n", function()
				mc.matchAddCursor(1)
			end)
			set({ "n", "x" }, "<leader>s", function()
				mc.matchSkipCursor(1)
			end)
			set({ "n", "x" }, "<leader>N", function()
				mc.matchAddCursor(-1)
			end)
			set({ "n", "x" }, "<leader>S", function()
				mc.matchSkipCursor(-1)
			end)

			-- In normal/visual mode, press `mwap` will create a cursor in every match of
			-- the word captured by `iw` (or visually selected range) inside the bigger
			-- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
			set({ "n", "x" }, "mw", function()
				mc.operator({ motion = "iw", visual = true })
				-- Or you can pass a pattern, press `mwi{` will select every \w,
				-- basically every char in a `{ a, b, c, d }`.
				-- mc.operator({ pattern = [[\<\w]] })
			end)

			-- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
			set("n", "mW", mc.operator)

			-- Add all matches in the document
			set({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

			-- You can also add cursors with any motion you prefer:
			-- set("n", "<right>", function()
			--     mc.addCursor("w")
			-- end)
			-- set("n", "<leader><right>", function()
			--     mc.skipCursor("w")
			-- end)

			-- Rotate the main cursor.
			set({ "n", "x" }, "<left>", mc.nextCursor)
			set({ "n", "x" }, "<right>", mc.prevCursor)

			-- Delete the main cursor.
			set({ "n", "x" }, "<leader>x", mc.deleteCursor)

			-- Add and remove cursors with control + left click.
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)

			-- Easy way to add and remove cursors using the main cursor.
			set({ "n", "x" }, "<c-q>", mc.toggleCursor)

			-- Clone every cursor and disable the originals.
			set({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors)

			set("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				elseif mc.hasCursors() then
					mc.clearCursors()
				else
					-- Default <esc> handler.
				end
			end)

			-- bring back cursors if you accidentally clear them
			set("n", "<leader>gv", mc.restoreCursors)

			-- Align cursor columns.
			set("n", "<leader>a", mc.alignCursors)

			-- Split visual selections by regex.
			set("x", "S", mc.splitCursors)

			-- Append/insert for each line of visual selections.
			set("x", "I", mc.insertVisual)
			set("x", "A", mc.appendVisual)

			-- match new cursors within visual selections by regex.
			set("x", "M", mc.matchCursors)

			-- Rotate visual selection contents.
			set("x", "<leader>t", function()
				mc.transposeCursors(1)
			end)
			set("x", "<leader>T", function()
				mc.transposeCursors(-1)
			end)

			-- Jumplist support
			set({ "x", "n" }, "<c-i>", mc.jumpForward)
			set({ "x", "n" }, "<c-o>", mc.jumpBackward)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { link = "Cursor" })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
	{
		"folke/edgy.nvim",
		---@module 'edgy'
		---@param opts Edgy.Config
		lazy = true,
        enabled = true,
		optional = true,
		opts = function(_, opts)
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				opts[pos] = opts[pos] or {}
				table.insert(opts[pos], {
					ft = "snacks_terminal",
					size = { height = 0.3 },
					title = "%{b:snacks_terminal.id}: %{b:term_title}",
					filter = function(_buf, win)
						return vim.w[win].snacks_win
							and vim.w[win].snacks_win.position == pos
							and vim.w[win].snacks_win.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				})
			end
		end,
	},
}
