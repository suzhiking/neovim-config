return {
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = not vim.g.vscode,
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        -- lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        -- event = { "VeryLazy" },
        config = function()
            local ensure_installed = {
                "c",
                "cpp",
                "python",
                "rust",
                "lua",
            }
            local already_installed = require("nvim-treesitter.config").get_installed()
            local parsers_to_install = vim.iter(ensure_installed)
                :filter(function(parser) return not vim.tbl_contains(already_installed, parser) end)
                :totable()
            require("nvim-treesitter").install(parsers_to_install, { summary = false })
            require("nvim-treesitter").update()

            -- auto-start highlights & indentation
            vim.api.nvim_create_autocmd("FileType", {
                desc = "User: enable treesitter highlighting",
                callback = function(ctx)
                    -- highlights
                    local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

                    -- indent
                    local noIndent = {}
                    if hasStarted and not vim.list_contains(noIndent, ctx.match) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
            -- Auto-install and start parsers for any buffer
            -- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
            --     callback = function(event)
            --         local bufnr = event.buf
            --         local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
            --
            --         -- Skip if no filetype
            --         if filetype == "" then
            --             return
            --         end
            --
            --         -- Check if this filetype is already handled by explicit opts.ensure_installed config
            --         -- for _, filetypes in pairs(opts.ensure_installed) do
            --         --     local ft_table = type(filetypes) == "table" and filetypes or { filetypes }
            --         --     if vim.tbl_contains(ft_table, filetype) then
            --         --         return -- Already handled above
            --         --     end
            --         -- end
            --
            --         -- Get parser name based on filetype
            --         local parser_name = vim.treesitter.language.get_lang(filetype) -- might return filetype (not helpful)
            --         if not parser_name then
            --             return
            --         end
            --         -- Try to get existing parser (helpful check if filetype was returned above)
            --         local parser_configs = require("nvim-treesitter.parsers")
            --         if not parser_configs[parser_name] then
            --             return -- Parser not available, skip silently
            --         end
            --
            --         local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
            --
            --         if not parser_installed then
            --             -- If not installed, install parser synchronously
            --             require("nvim-treesitter").install({ parser_name }):wait(30000)
            --             vim.print(filetype)
            --         end
            --
            --         -- let's check again
            --         parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
            --
            --         if parser_installed then
            --             -- Start treesitter for this buffer
            --             vim.treesitter.start(bufnr, parser_name)
            --         end
            --     end,
            -- })
            --     require("nvim-treesitter").setup({
            --         auto_install = true,
            --         highlight = {
            --             enable = true,
            --             disable = { "latex" },
            --             additional_vim_regex_highlighting = { "latex", "markdown" },
            --         },
            --         indent = { enable = true, disable = { "typst", "python" } },
            --         textobjects = {
            --             select = {
            --                 enable = true,
            --
            --                 -- Automatically jump forward to textobj, similar to targets.vim
            --                 lookahead = true,
            --                 keymaps = {
            --                     -- You can use the capture groups defined in textobjects.scm
            --                     ["p"] = "@parameter.outer"
            --                 },
            --             },
            --             swap = {
            --                 enable = true,
            --                 swap_next = {
            --                     ["gl"] = "@parameter.inner",
            --                 },
            --                 swap_previous = {
            --                     ["gh"] = "@parameter.inner",
            --                 },
            --             },
            --             move = {
            --                 enable = true,
            --                 set_jumps = true, -- whether to set jumps in the jumplist
            --                 goto_next_start = {
            --                     ["]f"] = "@function.outer",
            --                     --
            --                     -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
            --                     ["]o"] = "@loop.*",
            --                     -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --                     --
            --                     -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            --                     -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            --                     ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
            --                     ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            --                     ["]a"] = "@parameter.inner",
            --                     -- ["<C-f>"] = "@parameter.inner",
            --                     ["]e"] = "@return.inner",
            --                 },
            --                 goto_previous_start = {
            --                     ["[f"] = "@function.outer",
            --                     ["[a"] = "@parameter.inner",
            --                     ["[["] = "@class.outer",
            --                     -- ["<C-b>"] = "@parameter.inner",
            --                     ["[e"] = "@return.inner",
            --                     ["M"] = { query = "@local.scope", query_group = "locals", desc = "Prev scope" },
            --                 },
            --                 goto_next_end = {
            --                     ["]]"] = "@class.outer",
            --                 },
            --                 goto_previous_end = {
            --                     ["[]"] = "@class.outer",
            --                 },
            --                 -- Below will go to either the start or the end, whichever is closer.
            --                 -- Use if you want more granular movements
            --                 -- Make it even more gradual by adding multiple queries and regex.
            --                 goto_next = {
            --                     ["]C"] = "@conditional.outer",
            --                     ["]F"] = "@function.outer",
            --                 },
            --                 goto_previous = {
            --                     ["[C"] = "@conditional.outer",
            --                     ["[F"] = "@function.inner",
            --                 },
            --             },
            --         },
            --         incremental_selection = {
            --             enable = true,
            --             keymaps = {
            --                 -- init_selection = "gnn", -- set to `false` to disable one of the mappings
            --                 node_incremental = "v",
            --                 -- scope_incremental = "grc",
            --                 node_decremental = "V",
            --             },
            --         },
            --     })
            --     -- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            --     -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            --     --          vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        keys = {
            {
                "gl",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner", "textobjects")
                end,
                desc = "Swap with next parameter",
                mode = { "n", "x" }
            },
            {
                "gh",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner", "textobjects")
                end,
                desc = "Swap with previous parameter",
                mode = { "n", "x" }
            },
            {
                "]f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                desc = "Jump to next function start",
                mode = { "n", "x" }
            },
            {
                "[f",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                desc = "Jump to previous function start",
                mode = { "n", "x" }
            },
            {
                "]F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                end,
                desc = "Jump to next function end",
                mode = { "n", "x" }
            },
            {
                "[F",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                desc = "Jump to previous function end",
                mode = { "n", "x" }
            },
            {
                "]s",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next("@local.scope", "locals")
                end,
                desc = "Jump to previous scope",
                mode = { "n", "x" }
            },
            {
                "[s",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous("@local.scope", "locals")
                end,
                desc = "Jump to previous scope",
                mode = { "n", "x" }
            },
            {
                "[e",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous("@return.inner", "textobjects")
                end,
                desc = "Jump to previous return",
                mode = { "n", "x" }
            },
            {
                "]e",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next("@return.inner", "textobjects")
                end,
                desc = "Jump to next return",
                mode = { "n", "x" }
            },
            {
                "][",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@class.inner", "textobjects")
                end,
                desc = "Jump to next class start",
                mode = { "n", "x" }
            },
            {
                "]]",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@class.inner", "textobjects")
                end,
                desc = "Jump to next class end",
                mode = { "n", "x" }
            },
            {
                "[[",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.inner", "textobjects")
                end,
                desc = "Jump to previous class start",
                mode = { "n", "x" }
            },
            {
                "[]",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.inner", "textobjects")
                end,
                desc = "Jump to previous class end",
                mode = { "n", "x" }
            },
        },
        ---@module "nvim-treesitter-textobjects"
        opts = { multiwindow = true },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        event = "VeryLazy",
        config = function()
            local tsc = require("treesitter-context")
            tsc.setup({
                enable = false,
                mode = "cursor",
                max_lines = 3,
            })

            vim.g.toggle
                .new({
                    name = "Treesitter Context",
                    get = function()
                        return tsc.enabled()
                    end,
                    set = function(state)
                        if state then
                            tsc.enable()
                        else
                            tsc.disable()
                        end
                    end,
                })
                :map("<leader>uC")
            vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Visual" })
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Visual" })
            -- vim.cmd("hi TreesitterContextLineNumber guibg=background")
            -- -- vim.cmd("hi TreesitterContextSeparator gui=underline")
            -- -- vim.cmd("hi TreesitterContextBottom gui=underline")
            -- vim.cmd("hi clear TreesitterContextSeparator")
            -- vim.cmd("hi clear TreesitterContextBottom")
            vim.cmd("hi TreesitterContextBottom gui=none guisp=none")
            vim.cmd("hi TreesitterContextLineNumberBottom gui=none guisp=none")
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true, desc = "Jump to parent context" })
        end,
    },
}
