return {
	{
		"kawre/neotab.nvim",
        optional = true,
        enabled = false,
		event = "InsertEnter",
		opts = {
			-- configuration goes here
			tabkey = "",
			behavior = "closing",
			pairs = {
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "<", close = ">" },
				-- For typst
				{ open = "$", close = "$" },
				{ open = "_", close = "_" },
				{ open = "*", close = "*" },
			},
		},
		opt = true, -- Set this to true if the plugin is optional
	},
}
