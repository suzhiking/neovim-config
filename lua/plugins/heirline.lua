return {
	"rebelot/heirline.nvim",
	lazy = true,
	enabled = true,
	event = { "BufReadPre", "BufNewFile", "BufWritePost" },
	config = function(opts)
		local utils = require("heirline.utils")
		local conditions = require("heirline.conditions")
		local get_icon = require("utils").get_icon
		local get_highlight = function(hl)
			return vim.api.nvim_get_hl(0, { name = hl })
		end
		local function setup_colors()
			return {
				bright_bg = get_highlight("Folded").bg,
				bright_fg = get_highlight("Folded").fg,
				red = get_highlight("DiagnosticError").fg,
				dark_red = get_highlight("DiffDelete").bg,
				green = get_highlight("String").fg,
				blue = get_highlight("Function").fg,
				gray = get_highlight("NonText").fg,
				orange = get_highlight("Constant").fg,
				purple = get_highlight("Statement").fg,
				cyan = get_highlight("Character").fg,
				diag_warn = get_highlight("DiagnosticWarn").fg,
				diag_error = get_highlight("DiagnosticError").fg,
				diag_hint = get_highlight("DiagnosticHint").fg,
				diag_info = get_highlight("DiagnosticInfo").fg,
				git_del = get_highlight("GitSignsDelete").fg,
				git_add = get_highlight("GitSignsAdd").fg,
				git_change = get_highlight("GitSignsChange").fg,
				light_text = get_highlight("Normal").fg,
				dark_text = "#292c3c",
				surface = get_highlight("ColorColumn").bg,
                special = get_highlight("Special").fg,
			}
		end
		local colors = setup_colors()

		local Align = { provider = "%=" }
		local Space = { provider = " " }
		local LeftDivider = { provider = "█" }
		local RightDivider = { provider = "█" }
		-- Now we define some dictionaries to map the output of mode() to the
		-- corresponding string and color. We can put these into `static` to compute
		-- them at initialisation time.
		static = {
			mode_names = { -- change the strings if you like it vvvvverbose!
				n = "N",
				no = "NORMAL",
				nov = "NORMAL",
				noV = "NORMAL",
				["no\22"] = "NORMAL",
				niI = "NORMAL",
				niR = "NORMAL",
				niV = "NORMAL",
				nt = "NORMAL",
				v = "V",
				vs = "VISUAL",
				V = "V",
				Vs = "VISUAL",
				["\22"] = "VISUAL",
				["\22s"] = "VISUAL",
				s = "S",
				S = "S",
				["\19"] = "SELECT",
				i = "I",
				ic = "INSERT",
				ix = "INSERT",
				R = "REPLACE",
				Rc = "REPLACE",
				Rx = "REPLACE",
				Rv = "REPLACE",
				Rvc = "REPLACE",
				Rvx = "REPLACE",
				c = "COMMAND",
				cv = "Ex",
				r = "...",
				rm = "M",
				["r?"] = "?",
				["!"] = "!",
				t = "TERMINAL",
			},
			mode_colors = {
				n = "blue",
				i = "green",
				v = "purple",
				V = "purple",
				["\22"] = "cyan",
				c = "orange",
				s = "purple",
				S = "purple",
				["\19"] = "purple",
				R = "orange",
				r = "orange",
				["!"] = "red",
				t = "green",
			},
		}

		local mode = function(provider)
			return {
				-- get vim current mode, this information will be required by the provider
				-- and the highlight functions, so we compute it only once per component
				-- evaluation and store it as a component attribute
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,
				-- Now we define some dictionaries to map the output of mode() to the
				-- corresponding string and color. We can put these into `static` to compute
				-- them at initialisation time.
				static = static,
				-- We can now access the value of mode() that, by now, would have been
				-- computed by `init()` and use it to index our strings dictionary.
				-- note how `static` fields become just regular attributes once the
				-- component is instantiated.
				-- To be extra meticulous, we can also add some vim statusline syntax to
				-- control the padding and make sure our string is always at least 2
				-- characters long. Plus a nice Icon.
				provider = provider, -- Same goes for the highlight. Now the foreground will change according to the current mode.
				hl = function(self)
					local mode = self.mode:sub(1, 1) -- get only the first mode character
					return { fg = "#292c3c", bg = self.mode_colors[mode], bold = true }
				end,
				-- Re-evaluate the component only on ModeChanged event!
				-- Also allows the statusline to be re-evaluated when entering operator-pending mode
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}
		end

		local ViMode = mode(function(self)
			return "%2( " .. self.mode_names[self.mode] .. " %)"
		end)

		local FileIcon = {
			init = function(self)
				local filename = vim.api.nvim_buf_get_name(0)
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}
		local FileType = {
			provider = function()
				return string.lower(vim.bo.filetype)
			end,
			hl = { fg = "light_text", bold = true },
		}

		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
				return ("[" .. enc .. "]")
			end,
			hl = { fg = "light_text", bold = true },
		}

		local FileFormat = {
			provider = function()
				local fmt = vim.bo.fileformat
				return ("[" .. fmt .. "]")
			end,
			hl = { fg = "light_text", bold = true },
		}

		-- We're getting minimalist here!
		local Ruler = mode(" %3(%l%):%2c ")
		local Percentage = {
			provider = " %P ",
			hl = { bg = "surface", fg = "light_text", bold = true },
		}

		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },

			-- You can keep it simple,
			-- provider = " [LSP]",

			-- Or complicate things a bit and get the servers names
			provider = function()
				local names = {}
				for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return " [" .. table.concat(names, " ") .. "]"
			end,
			hl = { fg = "green", bold = true },
		}

		local Diagnostics = {

			condition = conditions.has_diagnostics,
			-- Example of defining custom LSP diagnostic icons, you can copypaste in your config:
			--vim.diagnostic.config({
			--  signs = {
			--    text = {
			--      [vim.diagnostic.severity.ERROR] = '',
			--      [vim.diagnostic.severity.WARN] = '',
			--      [vim.diagnostic.severity.INFO] = '󰋇',
			--      [vim.diagnostic.severity.HINT] = '󰌵',
			--    },
			--  },
			--})
			-- Fetching custom diagnostic icons

			-- If you defined custom LSP diagnostics with vim.fn.sign_define(), use this instead
			-- Note defining custom LSP diagnostic this way its deprecated, though
			--static = {
			--    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
			--    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
			--    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
			--    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
			--},

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				self.error_icon = " "
				self.warn_icon = " "
				self.info_icon = "󰋼 "
				self.hint_icon = "󰌵 "
			end,

			update = { "DiagnosticChanged", "BufEnter" },

            Space,
            Space,
			{
				provider = function(self)
					-- 0 is just another output, we can decide to print it or not!
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = "diag_error" },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = "diag_warn" },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = "diag_info" },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = "diag_hint" },
			},
			Space,
			Space,
			-- hl = { bg = "surface" },
		}

		local Git = {
			condition = conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,

			-- hl = { fg = "orange", bg = "surface" },
			hl = { fg = "orange" },

			Space,
			Space,
			{ -- git branch name
				provider = function(self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			-- You could handle delimiters, icons and counts similar to Diagnostics
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = "green" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = "red" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = "orange" },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
			},
		}

		local DAPMessages = {
			condition = function()
				local session = require("dap").session()
				return session ~= nil
			end,
			provider = function()
				return " " .. require("dap").status()
			end,
			hl = "Debug",
			-- see Click-it! section for clickable actions
		}

		local HelpFileName = {
			condition = function()
				return vim.bo.filetype == "help"
			end,
			provider = function()
				local filename = vim.api.nvim_buf_get_name(0)
				return vim.fn.fnamemodify(filename, ":t")
			end,
			hl = { fg = colors.blue },
		}

		local CodeInfo = {
			Git,
			Diagnostics,
		}

		local FileInfo = {
			Space,
			Space,
			LSPActive,
			Space,
			Space,
			FileFormat,
			Space,
			Space,
			FileEncoding,
			Space,
			Space,
			FileIcon,
			FileType,
			Space,
			Space,
			-- hl = { bg = "surface" },
		}

		local DefaultStatusline = {
			ViMode,
			CodeInfo,
			Align,
			DAPMessages,
			Align,
			Space,
			Space,
			FileInfo,
			Percentage,
			Ruler,
		}

		local heirline = require("heirline")
		heirline.load_colors(colors)
		heirline.setup({
			colors = colors,
			statusline = DefaultStatusline,
		})

		-- require("heirline").load_colors(setup_colors)
		-- or pass it to config.opts.colors

		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(setup_colors)
			end,
			group = "Heirline",
		})
	end,
}
