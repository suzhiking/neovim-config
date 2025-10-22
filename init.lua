-- Install Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("neovide")
require("vscode-options")
require("lazy").setup("plugins", {
	ui = {
		border = "rounded",
        backdrop = 100,
	},
})
require("colorscheme")
-- require("menu")

for _, source in ipairs({
	"autocmds",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end

-- local should_profile = os.getenv("NVIM_PROFILE")
-- if should_profile then
--   require("profile").instrument_autocmds()
--   if should_profile:lower():match("^start") then
--     require("profile").start("*")
--   else
--     require("profile").instrument("*")
--   end
-- end
--
-- local function toggle_profile()
--   local prof = require("profile")
--   if prof.is_recording() then
--     prof.stop()
--     vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
--       if filename then
--         prof.export(filename)
--         vim.notify(string.format("Wrote %s", filename))
--       end
--     end)
--   else
--     prof.start("*")
--   end
-- end
-- vim.keymap.set("n", "<c-u>", toggle_profile)
