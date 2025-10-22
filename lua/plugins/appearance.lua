return {
    {
        "folke/noice.nvim",
        lazy = false,
        -- enabled = not vim.g.vscode,
        enabled = true,
        event = "VeryLazy",
        opts = {
            cmdline = {
                view = "cmdline",
                -- view = "cmdline_popup",
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true,              -- enables the Noice messages UI
                view = "notify",             -- default view for messages
                view_error = "notify",       -- view for errors
                view_warn = "notify",        -- view for warnings
                view_history = "messages",   -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
            },
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
                hover = { enabled = true },
                signature = { enabled = false }
            },
            popupmenu = {
                backend = "nui",
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                lsp_doc_border = true,        -- add a border to hover docs and signature help
            },                                -- add any options here
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                },
            },
            views = {
                hover = {
                    border = { style = "single", highlight = "Normal:Normal,FloatBorder:FloatBorder,NormalFloat:None" },
                    size = { max_width = 80 },
                },
            },
        },
        config = function(_, opts)
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            require("noice").setup(opts)
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "dstein64/nvim-scrollview",
        -- optional = true,
        enabled = false,
        -- enabled = not vim.g.neovide, -- existing bug with neovide
        -- enabled = true, -- existing bug with neovide
        lazy = true,
        event = "VeryLazy",
        opts = {
            signs_on_startup = {},
            excluded_filetypes = { "neo-tree" },
        },
    },
    -- Enable these if you want mosue support with pretty UI
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     enabled = false,
    --     event = "VeryLazy",
    --     main = "ibl",
    --     opts = function()
    --         Snacks.toggle({
    --             name = "Indention Guides",
    --             get = function()
    --                 return require("ibl.config").get_config(0).enabled
    --             end,
    --             set = function(state)
    --                 require("ibl").setup_buffer(0, { enabled = state })
    --             end,
    --         }):map("<leader>ug")
    --
    --         return {
    --             indent = {
    --                 char = "│",
    --                 tab_char = "│",
    --             },
    --             -- scope = { show_start = false, show_end = false, highlight = "Special" },
    --             scope = { show_start = false, show_end = false, },
    --             exclude = {
    --                 filetypes = {
    --                     "Trouble",
    --                     "alpha",
    --                     "dashboard",
    --                     "help",
    --                     "lazy",
    --                     "mason",
    --                     "neo-tree",
    --                     "notify",
    --                     "snacks_dashboard",
    --                     "snacks_notif",
    --                     "snacks_terminal",
    --                     "snacks_win",
    --                     "toggleterm",
    --                     "trouble",
    --                 },
    --             },
    --         }
    --     end,
    -- },
    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next Todo Comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous Todo Comment",
            },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                                         desc = "Todo (Trouble)" },
            {
                "<leader>xT",
                "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
                desc = "Todo/Fix/Fixme (Trouble)",
            },
            { "<leader>fT", function() Snacks.picker.todo_comments() end,                                           desc = "Todo" },
            -- { "<leader>fT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,  desc = "Todo/Fix/Fixme" },
        },
        opts = {
            signs = false,
        },
    },
}
