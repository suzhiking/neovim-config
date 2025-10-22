return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = true,
		enabled = false,
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		config = function()
			vim.o.laststatus = vim.g.lualine_laststatus
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 3,
					component_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "snacks_dashboard" } },
				},
				globalstatus = false,
				sections = {
					lualine_b = {
						"branch",
						"diagnostics",
					},
					lualine_c = {
						{
							function()
								local statusline = require("arrow.statusline")
								return statusline.text_for_statusline_with_icons()
							end,
						},
					},
					lualine_x = {
						{ -- macro recording
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						{ -- key strokes
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
							color = { fg = "#ff9e64" },
						},
						"encoding",
						"fileformat",
						"filetype",
					},
				},
				refresh = {
					statusline = 100,
				},
			})
		end,
	},
}
