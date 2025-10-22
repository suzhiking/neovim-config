local get_icon = require("utils").get_icon
return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = get_icon("GitSign") },
                    change = { text = get_icon("GitSign") },
                    delete = { text = get_icon("GitSign") },
                    topdelete = { text = get_icon("GitSign") },
                    changedelete = { text = get_icon("GitSign") },
                    untracked = { text = get_icon("GitSign") },
                },
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]h", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end, { desc = "Next hunk" })

                    map("n", "[h", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end, { desc = "Prev hunk" })

                    -- Actions
                    -- map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
                    -- map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Rest hunk" })
                    map("v", "<leader>gs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Stage hunk" })
                    map("v", "<leader>gr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Reset hunk" })
                    map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset stage hunk" })
                    map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
                    -- map("n", "<leader>hb", function()
                    -- 	gitsigns.blame_line({ full = true })
                    -- end, { desc = "Blame line" })

                    local config = require("gitsigns.config").config
                    vim.g.toggle
                        .new({
                            name = "Git Deleted",
                            get = function()
                                return config.show_deleted
                            end,
                            set = function(state)
                                gitsigns.toggle_deleted(state)
                            end,
                        })
                        :map("<leader>uD")
                    vim.g.toggle
                        .new({
                            name = "Git Blame",
                            get = function()
                                return config.current_line_blame
                            end,
                            set = function(state)
                                gitsigns.toggle_current_line_blame(state)
                            end,
                        })
                        :map("<leader>uB")
                    -- map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
                    -- map("n", "<leader>gD", function()
                    -- 	gitsigns.diffthis("~")
                    -- end, { desc = "Diff this ~" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })
                end,
            })
        end,
    },
    {
        "sindrets/diffview.nvim",
        lazy = true,
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewLog" },
        keys = {
            {
                "<leader>gd",
                function()
                    -- local last_tabpage = vim.api.nvim_get_current_tabpage()
                    local lib = require("diffview.lib")
                    local view = lib.get_current_view()
                    if view then
                        -- Current tabpage is a Diffview; close it
                        vim.cmd(":DiffviewClose")
                    else
                        -- No open Diffview exists: open a new one
                        vim.cmd(":DiffviewOpen")
                    end
                end,
                desc = "Diff view",
            },
            {
                "<leader>gF",
                function()
                    local user_input = vim.fn.input("Files to Open: ")
                    vim.cmd("DiffviewFileHistory" .. user_input)
                end,
                desc = "Open DiffView on Files"
            },
            {
                "<leader>go",
                function()
                    local user_input = vim.fn.input("Revision to Open: ")
                    vim.cmd("DiffviewOpen " .. user_input)
                end,
                desc = "Open DiffView"
            }
        },
        config = function()
            require("diffview").setup()
        end,
    },
    -- Use Lazygit instead of this
    {
        "NeogitOrg/neogit",
        enabled = true,
        lazy = true,
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
        },
        config = true,
    },
}
