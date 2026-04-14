return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            -- transparent_background = true,
            -- float = {
            --     transparent = true, -- enable transparent floating windows
            --     solid = false, -- use solid styling for floating windows, see |winborder|
            -- },
            background = {
                light = "frappe",
                dark = "mocha",
            },
            term_colors = true,
            custom_highlights = function(colors)
                return {
                    ["@string.documentation"] = { link = "String" },
                }
            end,
            integrations = {
                telescope = {
                    enabled = true,
                    -- style = "nvchad",
                },
                blink_cmp = true,
                grug_far = true,
                noice = true,
                notify = true,
                snacks = true,
                lsp_trouble = true,
                which_key = true,
                dropbar = {
                    enabled = true,
                    color_mode = true, -- enable color for kind's texts, not just kind's icons
                },
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
        end,
    },
    {
        "navarasu/onedark.nvim",
        optional = not vim.g.opt_themes,
        enabled = vim.g.opt_themes,
        priority = 1000, -- ensure it loads first
        -- config = function()
        -- 	-- somewhere in your config:
        -- end,
    },
    {
        "luisiacc/the-matrix.nvim",
        optional = not vim.g.opt_themes,
        enabled = vim.g.opt_themes,
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        -- optional = not vim.g.opt_themes,
        -- enabled = vim.g.opt_themes,
        priority = 1000,
        opts = {
            transparent = false,
            styles = {
                sidebars = "transparent",
                -- floats = "transparent",
            },
            sections = {},
        },
    },
    {
        "sainnhe/gruvbox-material",
        -- optional = not vim.g.opt_theme,
        enabled = true,
        priority = 1000,
        -- config = function ()
        --     vim.g.gruvbox_material_enable_italic = true
        -- end
    },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        -- optional = not vim.g.opt_themes,
        -- enabled = vim.g.opt_themes,
    },
    {
        "xiyaowong/transparent.nvim",
        enabled = not vim.g.neovide,
        config = function()
            -- Optional, you don't have to run setup.
            require("transparent").setup({
                -- table: default groups
                groups = {
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                    'EndOfBuffer', "BufferLineGroupLabel", "BufferLineTab", "TinyInlineDiagnosticVirtualTextHint",
                    "TinyInlineDiagnosticVirtualTextInfo", "TinyInlineDiagnosticVirtualTextWarn", "TinyInlineDiagnosticVirtualTextError",
                    "TablineFill", "Tabline"
                },
                -- table: additional groups that should be cleared
                extra_groups = {},
                -- table: groups you don't want to clear
                exclude_groups = {},
                -- function: code to be executed after highlight groups are cleared
                -- Also the user event "TransparentClear" will be triggered
                on_clear = function() end,
            })
        end
    },
    {
        "ydkulks/cursor-dark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme("cursor-dark-midnight")
            require("cursor-dark").setup({
                -- For theme
                style = "dark",
                -- For a transparent background
                transparent = true,
                -- If you have dashboard-nvim plugin installed
                dashboard = true,
            })
        end,
    },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
    },
    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "serhez/teide.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    }
}
