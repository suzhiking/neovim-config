return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			background = {
				light = "frappe",
				dark = "mocha",
			},
			term_colors = true,
			integrations = {
				telescope = {
					enabled = true,
					-- style = "nvchad",
				},
				blink_cmp = true,
				grug_far = true,
				noice = true,
				notify = true,
				snacks = true,
				lsp_trouble = true,
				which_key = true,
				dropbar = {
					enabled = true,
					color_mode = true, -- enable color for kind's texts, not just kind's icons
				},
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000, -- ensure it loads first
		-- config = function()
		-- 	-- somewhere in your config:
		-- end,
	},
	{
		"luisiacc/the-matrix.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000,
	},
	{
		"diegoulloao/neofusion.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000,
		config = true,
	},
	{
		"folke/tokyonight.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000,
		opts = {
			transparent = false,
			styles = {
				sidebars = "transparent",
				-- floats = "transparent",
			},
			sections = {},
		},
	},
	{
		"projekt0n/github-nvim-theme",
		enabled = vim.g.opt_themes,
		optional = not vim.g.opt_themes,
		priority = 1000,
	},
	{
		"sainnhe/gruvbox-material",
		-- optional = not vim.g.opt_theme,
		enabled = true,
		priority = 1000,
        -- config = function ()
        --     vim.g.gruvbox_material_enable_italic = true
        -- end
	},
	{
		"rose-pine/neovim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		lazy = false,
		priority = 1000,
		name = "rose-pine",
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
	},
	{
		"Mofiqul/vscode.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000,
	},
	{
		"loctvl842/monokai-pro.nvim",
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
		priority = 1000,
	},
	{
		"marko-cerovac/material.nvim",
		priority = 1000,
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
	},
	{
		"bluz71/vim-moonfly-colors",
		priority = 1000,
		optional = not vim.g.opt_themes,
		enabled = vim.g.opt_themes,
	},
}
