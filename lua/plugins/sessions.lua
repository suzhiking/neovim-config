return {
	-- Lua
	{
		"folke/persistence.nvim",
        enabled = true,
		lazy = true,
		event = "VeryLazy", -- this will only start session saving when an actual file was opened
		config = function()
			require("persistence").setup()

			-- load the session for the current directory
			vim.keymap.set("n", "<leader>S.", function()
				require("persistence").load()
			end, { desc = "Load current session" })

			-- select a session to load
			vim.keymap.set("n", "<leader>SS", function()
				require("persistence").select()
			end, { desc = "Search sessions" })

			-- load the last session
			vim.keymap.set("n", "<leader>Sl", function()
				require("persistence").load({ last = true })
			end, { desc = "Load last session" })

			-- stop Persistence => session won't be saved on exit
			vim.keymap.set("n", "<leader>Sd", function()
				require("persistence").stop()
			end, { desc = "Stop session save" })

            -- vim.api.nvim_create_autocmd("PersistenceSavePre", {
            --     callback = function()
            --         vim.api.close
            --     end
            -- })
		end,
	},
	-- {
	-- 	"stevearc/resession.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		local resession = require("resession")
	-- 		resession.setup()
	-- 		-- Resession does NOTHING automagically, so we have to set up some keymaps
	-- 		vim.keymap.set("n", "<leader>Ss", resession.save)
	-- 		vim.keymap.set("n", "<leader>Sl", resession.load)
	-- 		vim.keymap.set("n", "<leader>Sd", resession.delete)
	--
	-- 		vim.api.nvim_create_autocmd("VimLeavePre", {
	-- 			callback = function()
	-- 				-- Always save a special session named "last"
	-- 				resession.save("last")
	-- 			end,
	-- 		})
	-- 		local function get_session_name()
	-- 			local name = vim.fn.getcwd()
	-- 			local branch = vim.trim(vim.fn.system("git branch --show-current"))
	-- 			if vim.v.shell_error == 0 then
	-- 				return name .. branch
	-- 			else
	-- 				return name
	-- 			end
	-- 		end
	-- 		-- vim.api.nvim_create_autocmd("VimEnter", {
	-- 		-- 	callback = function()
	-- 		-- 		-- Only load the session if nvim was started with no args
	-- 		-- 		if vim.fn.argc(-1) == 0 then
	-- 		-- 			resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
	-- 		-- 		end
	-- 		-- 	end,
	-- 		-- })
	-- 		vim.api.nvim_create_autocmd("VimLeavePre", {
	-- 			callback = function()
	-- 				resession.save(get_session_name(), { dir = "dirsession", notify = false })
	-- 			end,
	-- 		})
	--            vim.keymap.set("n", "<leader>S.", function() resession.load(get_session_name(), { dir = "dirsession", silence_errors = true }) end)
	-- 	end,
	-- },
}
