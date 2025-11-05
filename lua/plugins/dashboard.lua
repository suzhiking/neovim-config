return {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                header = [[
 I use                                                             
      ████ ██████           █████      ██                 btw
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
                    ]],
                keys = {
                    {
                        icon = " ",
                        key = "f",
                        desc = "Find File",
                        action = ":lua Snacks.dashboard.pick('files')",
                    },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    {
                        icon = " ",
                        key = "g",
                        desc = "Find Text",
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = " ",
                        key = "r",
                        desc = "Recent Files",
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
    }
    -- Hide cursor in dashboard
    -- vim.api.nvim_create_autocmd("User", {
    -- 	pattern = "SnacksDashboardOpened",
    -- 	callback = function()
    -- 		local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    -- 		hl.blend = 100
    -- 		vim.api.nvim_set_hl(0, "Cursor", hl)
    -- 		vim.cmd("set guicursor+=a:Cursor/lCursor")
    -- 	end,
    -- })
    -- vim.api.nvim_create_autocmd("User", {
    -- 	pattern = "SnacksDashboardClosed",
    -- 	callback = function()
    -- 		local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    -- 		hl.blend = 0
    -- 		vim.api.nvim_set_hl(0, "Cursor", hl)
    -- 		-- vim.opt.guicursor.append("a:Cursor/lCursor")
    -- 		vim.cmd("set guicursor+=a:Cursor/lCursor")
    -- 	end,
    -- })
}
