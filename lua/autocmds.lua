local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local cmd = vim.api.nvim_create_user_command
-- local namespace = vim.api.nvim_create_namespace
local utils = require("utils")
local is_available = utils.is_available

-- if is_available("neo-tree.nvim") then
-- 	autocmd("BufEnter", {
-- 		desc = "Open Neo-Tree on startup with directory",
-- 		group = augroup("neotree_start", { clear = true }),
-- 		callback = function()
-- 			if package.loaded["neo-tree"] then
-- 				vim.api.nvim_del_augroup_by_name("neotree_start")
-- 			else
-- 				local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
-- 				if stats and stats.type == "directory" then
-- 					vim.api.nvim_del_augroup_by_name("neotree_start")
-- 					require("neo-tree")
-- 				end
-- 			end
-- 		end,
-- 	})
-- 	autocmd("TermClose", {
-- 		pattern = "*lazygit*",
-- 		desc = "Refresh Neo-Tree when closing lazygit",
-- 		group = augroup("neotree_refresh", { clear = true }),
-- 		callback = function()
-- 			local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
-- 			if manager_avail then
-- 				for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
-- 					local module = "neo-tree.sources." .. source
-- 					if package.loaded[module] then
-- 						manager.refresh(require(module).name)
-- 					end
-- 				end
-- 			end
-- 		end,
-- 	})
-- end


-- vim.api.nvim_create_autocmd(
--     {
--         "BufNewFile",
--         "BufRead",
--     },
--     {
--         pattern = "*.typ",
--         callback = function()
--             local buf = vim.api.nvim_get_current_buf()
--             -- vim.api.nvim_buf_set_option(buf, "filetype", "typst")
-- 			vim.api.nvim_set_option_value("filetype", "typst", {buf = buf})
--         end
--     }
-- )

