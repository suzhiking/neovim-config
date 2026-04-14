return { {
    "folke/sidekick.nvim",
    optional = true,
    enabled = false,
    opts = {
        -- add any options here
        cli = {
            mux = {
                backend = "tmux",
                enabled = true,
            },
        },
    },
    -- stylua: ignore
    keys = {
        {
            "<tab>",
            function()
                -- if there is a next edit, jump to it, otherwise apply it if any
                if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>" -- fallback to normal tab
                end
            end,
            expr = true,
            desc = "Goto/Apply Next Edit Suggestion",
        },
        {
            "<leader>aa",
            function() require("sidekick.cli").toggle() end,
            desc = "Sidekick Toggle CLI",
        },
        {
            "<leader>as",
            function() require("sidekick.cli").select() end,
            -- Or to select only installed tools:
            -- require("sidekick.cli").select({ filter = { installed = true } })
            desc = "Select CLI",
        },
        {
            "<leader>at",
            function() require("sidekick.cli").send({ msg = "{this}" }) end,
            mode = { "x", "n" },
            desc = "Send This",
        },
        {
            "<leader>av",
            function() require("sidekick.cli").send({ msg = "{selection}" }) end,
            mode = { "x" },
            desc = "Send Visual Selection",
        },
        {
            "<leader>ap",
            function() require("sidekick.cli").prompt() end,
            mode = { "n", "x" },
            desc = "Sidekick Select Prompt",
        },
        {
            "<c-.>",
            function() require("sidekick.cli").focus() end,
            mode = { "n", "x", "i", "t" },
            desc = "Sidekick Switch Focus",
        },
        -- Example of a keybinding to open Claude directly
        {
            "<leader>ac",
            function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
            desc = "Sidekick Toggle Claude",
        },
    },
},
    -- {
    --     "NickvanDyke/opencode.nvim",
    --     dependencies = {
    --         -- Recommended for `ask()` and `select()`.
    --         -- Required for `snacks` provider.
    --         ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    --         { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    --     },
    --     config = function()
    --         ---@type opencode.Opts
    --         vim.g.opencode_opts = {
    --             -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    --         }
    --
    --         -- Required for `opts.events.reload`.
    --         vim.o.autoread = true
    --
    --         -- Recommended/example keymaps.
    --         vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
    --             { desc = "Ask opencode" })
    --         vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
    --             { desc = "Execute opencode action…" })
    --         vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,
    --             { desc = "Toggle opencode" })
    --
    --         vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
    --             { expr = true, desc = "Add range to opencode" })
    --         vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
    --             { expr = true, desc = "Add line to opencode" })
    --
    --         vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
    --             { desc = "opencode half page up" })
    --         vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
    --             { desc = "opencode half page down" })
    --
    --         -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
    --         vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    --         vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    --     end,
    -- }
}
