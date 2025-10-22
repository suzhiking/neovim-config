local icons = require("icons.nerd_font")
return {
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "BufReadPre", "BufNewFile", "BufWritePost" },
		dependencies = {
			"mason-org/mason.nvim",
			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()

			-- Brief Aside: **What is LSP?**
			--
			-- LSP is an acronym you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself
					-- many times.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
					end

					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					map("<leader>cn", vim.lsp.buf.rename, "Rename")
					-- map("<leader>cn", ":IncRename ", "Rename")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map("K", vim.lsp.buf.hover, "Hover documentation")
					-- map("q", utils.close_floating_windows(), "Hover documentation")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header
					map("gD", vim.lsp.buf.declaration, "Goto declaration")

					map("go", vim.diagnostic.open_float, "Float diagonostics")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client.server_capabilities.codeLensProvider then
						vim.lsp.codelens.refresh({ bufnr = event.buf })
						vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
							buffer = event.buf,
							callback = function()
								vim.lsp.codelens.refresh({ bufnr = event.buf })
							end,
						})
					end

					if client and client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end
				end,
			})
			-- vim.api.nvim_create_autocmd("CursorHold", {
			--     callback = function()
			--         vim.diagnostic.open_float(nil, { focusable = false })
			--     end
			-- })

			vim.diagnostic.config({
				float = { border = "rounded" },
				virtual_text = true,
				virtual_lines = false,
				underline = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.DiagnosticError,
						[vim.diagnostic.severity.WARN] = icons.DiagnosticWarn,
						[vim.diagnostic.severity.HINT] = icons.DiagnosticHint,
						[vim.diagnostic.severity.INFO] = icons.DiagnosticInfo,
					},
				},
			})
			vim.keymap.set("n", "gK", function()
				local new_config = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({ virtual_lines = new_config })
			end, { desc = "Toggle diagnostic virtual_lines" })

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local M = {}
			local servers = {
				rust_analyzer = {},
				basedpyright = {
					enabled = true,
					settings = {
						basedpyright = {
							analysis = {
								-- ignore = { "*" },
								typeCheckingMode = "off",
								-- diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								reportAssignmentType = false,
							},
						},
					},
				},
				clangd = {
					-- on_attach = function(client)
					--     client.server_capabilities.completionProvider = false
					-- end,
					cmd = {
						"clangd",
						"--fallback-style=webkit",
						"--offset-encoding=utf-16",
						-- "--clang-tidy",
					},
					settings = {
						clangd = {
							arguments = { "-I/Users/zhisuw/cpython/Include" },
						},
					},
					handlers = {
						["textDocument/publishDiagnostics"] = function() end,
					},
				},
				lua_ls = {
					capabilities = {
						textDocument = {
							codeLens = {
								dynamicRegistration = false,
							},
						},
					},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				-- texlab = {},
				gopls = {},
				tinymist = {
					single_file_support = true,
					root_dir = function()
						return vim.fn.getcwd()
					end,
					settings = {
						-- exportPdf = "onType",
						exportPdf = "onSave",
						-- outputPath = "$root/target/$dir/$name",
					},
				},
			}

			require("mason").setup()

			for server_name, server in pairs(servers) do
				vim.lsp.config(server_name, server)
				vim.lsp.enable(server_name)
			end
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		enabled = false,
		-- version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		-- ft = "rust",
		keys = {
			{
				"gC",
				function()
					vim.cmd.RustLsp("openCargo")
				end,
				desc = "Open Cargo.toml",
			},
		},
		-- config = function()
		-- 	vim.g.rustaceanvim = {
		-- 		-- Plugin configuration
		-- 		tools = {},
		-- 		-- LSP configuration
		-- 		server = {
		-- 			-- on_attach = function(client, bufnr)
		-- 			-- 	-- you can also put keymaps in here
		-- 			-- end,
		-- 			default_settings = {
		-- 				-- rust-analyzer language server configuration
		-- 				["rust-analyzer"] = {
		-- 					cargo = {
		-- 						allFeatures = true,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 		-- DAP configuration
		-- 		dap = {},
		-- 	}
		-- end,
	},
	-- {
	--     "folke/trouble.nvim",
	--     opts = {}, -- for default options, refer to the configuration section for custom setup.
	--     config = function(_, opts)
	--         vim.api.nvim_set_hl(0, "TroubleNormal", { link = "Normal" })
	--         require("trouble").setup(opts)
	--     end,
	--     lazy = true,
	--     cmd = "Trouble",
	--     specs = {
	--         "folke/snacks.nvim",
	--         opts = function(_, opts)
	--             return vim.tbl_deep_extend("force", opts or {}, {
	--                 picker = {
	--                     actions = require("trouble.sources.snacks").actions,
	--                     win = {
	--                         input = {
	--                             keys = {
	--                                 ["<c-t>"] = {
	--                                     "trouble_open",
	--                                     mode = { "n", "i" },
	--                                 },
	--                             },
	--                         },
	--                     },
	--                 },
	--             })
	--         end,
	--     },
	--     keys = {
	--         {
	--             "<leader>xx",
	--             "<cmd>Trouble diagnostics toggle<cr>",
	--             desc = "Diagnostics (Trouble)",
	--         },
	--         {
	--             "<leader>xX",
	--             "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	--             desc = "Buffer Diagnostics (Trouble)",
	--         },
	--         {
	--             "<leader>xs",
	--             "<cmd>Trouble symbols toggle focus=false<cr>",
	--             desc = "Symbols (Trouble)",
	--         },
	--         {
	--             "<leader>xl",
	--             "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	--             desc = "LSP Definitions / references / ... (Trouble)",
	--         },
	--         {
	--             "<leader>xL",
	--             "<cmd>Trouble loclist toggle<cr>",
	--             desc = "Location List (Trouble)",
	--         },
	--         {
	--             "<leader>xQ",
	--             "<cmd>Trouble qflist toggle<cr>",
	--             desc = "Quickfix List (Trouble)",
	--         },
	--         {
	--             "(",
	--             function()
	--                 if require("trouble").is_open() then
	--                     require("trouble").prev({ skip_groups = true, jump = true })
	--                 else
	--                     local ok, err = pcall(vim.cmd.cprev)
	--                     if not ok then
	--                         vim.notify(err, vim.log.levels.ERROR)
	--                     end
	--                 end
	--             end,
	--             desc = "Previous Trouble/Quickfix Item",
	--             silent = true,
	--         },
	--         {
	--             ")",
	--             function()
	--                 if require("trouble").is_open() then
	--                     require("trouble").next({ skip_groups = true, jump = true })
	--                 else
	--                     local ok, err = pcall(vim.cmd.cnext)
	--                     if not ok then
	--                         vim.notify(err, vim.log.levels.ERROR)
	--                     end
	--                 end
	--             end,
	--             desc = "Next Trouble/Quickfix Item",
	--             silent = true,
	--         },
	--     },
	-- },
	{ -- LSP Info Dropbar
		"Bekaboo/dropbar.nvim",
		enabled = true,
		lazy = true,
		event = { "BufReadPost", "BufNewFile", "BufWritePost" },
		opts = {
			bar = {
				enable = function(buf, win, _)
					if
						not vim.api.nvim_buf_is_valid(buf)
						or not vim.api.nvim_win_is_valid(win)
						or vim.fn.win_gettype(win) ~= ""
						or vim.wo[win].winbar ~= ""
						or vim.bo[buf].ft == "snacks_picker_preview"
						or vim.bo[buf].ft == "snacks_picker_list"
						or vim.bo[buf].ft == "snacks_picker_input"
					then
						return false
					end

					local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
					if stat and stat.size > 1024 * 1024 then
						return false
					end

					return vim.bo[buf].ft == "markdown"
						or pcall(vim.treesitter.get_parser, buf)
						or not vim.tbl_isempty(vim.lsp.get_clients({
							bufnr = buf,
							method = "textDocument/documentSymbol",
						}))
				end,
			},
			sources = {
				path = {
					-- Change winbar status when file is modified
					modified = function(sym)
						return sym:merge({
							name = sym.name .. "[+]",
							icon = " ",
							name_hl = "DiffAdded",
							icon_hl = "DiffAdded",
							-- ...
						})
					end,
				},
				lsp = {
					valid_symbols = {
						"File",
						"Module",
						"Namespace",
						"Package",
						"Class",
						"Method",
						"Property",
						"Constructor",
						"Enum",
						"Interface",
						"Function",
						"Constant",
						"Array",
						"Object",
						"EnumMember",
						"Struct",
						"Event",
					},
				},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		enabled = false,
		config = function()
			require("lint").linters_by_ft = {
				python = { "ruff" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()
				end,
			})
		end,
	},
    {
        "stevearc/profile.nvim",
        lazy = false,
    }
}
