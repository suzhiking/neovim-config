local utils = require("utils")
local get_icon = utils.get_icon

return {
	"folke/which-key.nvim",
    enabled = true,
	lazy = true,
	event = "UIEnter",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps",
		},
	},
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		defaults = {
			{ "<leader>f", group = "Find", icon = { icon = get_icon("Find", 1, true), hl = "@function" } },
			{ "<leader>t", group = "Notes", icon = { icon = get_icon("Notes", 1, true), hl = "@chracter" } },
			{ "<leader>c", group = "Code", icon = { icon = get_icon("DiagnosticHint", 1, true), hl = "@float" } },
			{ "<leader>u", group = "UI/UX" },
			-- { "<leader>w", group = get_icon("WordFile", 1, true) .. "Workspace" },
			{ "<leader>S", group = "Session" },
			{ "<leader>d", group = "Debug", icon = { icon = get_icon("Debugger", 1, true), hl = "@error" } },
			{ "<leader>a", group = "AI", icon = { icon = get_icon("Spark", 1, true), hl = "@type" } },
			-- { "<leader>r", group = get_icon("ActiveLSP", 1, true) .. "Competition" },
			{ "<leader>r", group = "Refactor", icon = { icon = get_icon("ActiveLSP", 1, true), hl = "@comment" } },
			{ "<leader>g", group = "Git", icon = { icon = get_icon("Git", 1, true), hl = "@error" } },
			{ "<leader>x", group = "Diagnostic" },
			{ "<leader>o", group = "Tasks", icon = { icon = get_icon("Task", 1, true), hl = "@markup" } },
		},
		-- Defer popup for certain keys
		defer = function(ctx)
			if vim.list_contains({ "d", "y" }, ctx.operator) then
				return true
			end
			return vim.list_contains({ "<C-V>", "v", "V" }, ctx.mode)
		end,
        delay = function(ctx)
            return 0
        end,

		-- icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
		icons = {
			rules = {
				{ pattern = "session", icon = get_icon("Session", 1, true), hl = "@function" },
				{ pattern = "paste", icon = "", hl = "@string" },
				{ pattern = "yank", icon = "", hl = "@label" },
				-- { pattern = "insert", icon = "", hl = "@string" },
				{ pattern = "save", icon = "", hl = "@string" },
				{ pattern = "explorer", icon = "", hl = "@string" },
				{ pattern = "close", icon = "󰅗", hl = "@error" },
				{ pattern = "split", icon = "" },
				{ pattern = "neovim", icon = "", hl = "@string" },
				{ pattern = "find", icon = get_icon("Find", 1, true), hl = "@function" },
				{ pattern = "search", icon = get_icon("Find", 1, true), hl = "@function" },
				{ pattern = "left", icon = "" },
				{ pattern = "prev", icon = "" },
				{ pattern = "right", icon = "" },
				{ pattern = "next", icon = "" },
                { pattern = "operator", icon = "" },
			},
			group = "",
			separator = "",
		},
		disable = { filetypes = { "TelescopePrompt" } },
		preset = "helix",
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add(opts.defaults)
		wk.add({
			{ "<leader>.", icon = { icon = "󰇥", hl = "@type" } },
		})
	end,
}
