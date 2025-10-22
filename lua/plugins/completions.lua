return {
    {
        "saghen/blink.cmp",
        enabled = false,
        event = "InsertEnter",
        -- optional: provides snippets for the snippet source
        -- dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = {
                preset = "default",
                ["<Tab>"] = { "select_and_accept", "fallback" },
                ["<C-k>"] = { "select_prev" },
                ["<C-j>"] = { "select_next" },
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-n>"] = { "select_next" },
                ["<C-p>"] = { "select_prev" },
                ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            fuzzy = {
                sorts = {
                    "score",
                    "sort_text",
                },
            },

            cmdline = {
                enabled = true,
                keymap = {
                    preset = "default",
                    ["<Tab>"] = { "select_and_accept", "fallback" },
                    ["<C-k>"] = { "select_prev" },
                    ["<C-j>"] = { "select_next" },
                    ["<C-l>"] = { "snippet_forward", "fallback" },
                    ["<C-h>"] = { "snippet_backward", "fallback" },
                    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                    ["<C-n>"] = { "select_next" },
                    ["<C-p>"] = { "select_prev" },
                },
                completion = {
                    menu = {
                        auto_show = function()
                            local type = vim.fn.getcmdtype()
                            -- Search forward and backward
                            if type == "/" or type == "?" then
                                return { "buffer" }
                            end
                            -- Commands
                            if type == ":" or type == "@" then
                                return { "cmdline" }
                            end
                            return {}
                        end,
                        draw = {
                            columns = {
                                { "kind_icon", "kind",             gap = 1 },
                                { "label",     "label_description" },
                            },
                        },
                    },
                },
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        transform_items = function(ctx, items)
                            -- Remove the "Text" source from lsp autocomplete
                            return vim.tbl_filter(function(item)
                                return item.kind ~= vim.lsp.protocol.CompletionItemKind.Text
                            end, items)
                        end,
                    },
                },
            },

            -- experimental signature help support
            signature = {
                enabled = true,
                window = {
                    winblend = 10,
                    border = "single",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                },
            },

            completion = {
                list = {
                    selection = { preselect = true, auto_insert = false },
                },
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                    border = "single",
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 1,
                    window = {
                        border = "single",
                        winhighlight =
                        "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    },
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
                trigger = {
                    show_on_insert_on_trigger_character = false,
                },
            },
        },
        -- allows extending the providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.default" },
        config = function(_, opts)
            require("blink.cmp").setup(opts)
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                diable_in_macro = false,
                enable_check_bracket_line = true,
                enable_afterquote = true,
            })
            local Rule = require("nvim-autopairs.rule")
            local npairs = require("nvim-autopairs")
            local cond = require("nvim-autopairs.conds")

            npairs.add_rules({
                Rule("$", "$", { "typ", "typst", "markdown" }),
            })
            npairs.get_rules("`")[1].not_filetypes = { "typ", "typst" }
            -- Don't add pairs for quotes if it's after alphanumeric chars
            npairs.get_rules("'")[1]:with_pair(cond.not_before_regex("%w", 1))
            npairs.get_rules("`")[1]:with_pair(cond.not_before_regex("%w", 1))
            npairs.get_rules('"')[1]:with_pair(cond.not_before_regex("%w", 1))
            -- vim.keymap.set("v", ")", "sa)", { noremap = true, silent = true })
            -- vim.keymap.set("v", '"', 'sa"', { noremap = true, silent = true })
            -- vim.keymap.set("v", "'", "sa'", { noremap = true, silent = true })
            -- vim.keymap.set("v", "$", "sa$", { noremap = true, silent = true })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
