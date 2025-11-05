return {
    "akinsho/bufferline.nvim",
    lazy = true,
    enabled = true,
    event = "VeryLazy",
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup({
            options = {
                auto_toggle_bufferline = false,
                style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
                close_command = "bdelete %d",
                indicator = {
                    icon = '▎', -- this should be omitted if indicator style is not 'icon'
                    style = "none",
                },
                -- name_formatter = function(buf)
                -- 	if buf.name:match("%.*") then
                -- 		return vim.fn.fnamemodify(buf.name, ":t:r")
                -- 	end
                -- end,
                -- diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match("error") and " " or " "
                    return icon .. count
                end,
                offsets = { { filetype = "neo-tree", text = "Neotree", text_align = "center" } },
                enforce_regular_tabs = true,
                tab_size = 12,
                TabLineFill = { bg = bufferline.line_bg },
                separator_style = "slant"
            },
        })
        local show = true
        local snacks = require("snacks.toggle")
        snacks.new({
            name = "Bufferline",
            get = function()
                return show
            end,
            set = function(state)
                if state then
                    vim.opt.showtabline = 2
                    show = true
                else
                    vim.opt.showtabline = 0
                    show = false
                end
            end
        }):map("<leader>ut")
    end,
}
