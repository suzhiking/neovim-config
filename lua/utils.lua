local M = {}

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param kind string The kind of icon in astronvim.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@return string icon
function M.get_icon(kind, padding, fallback)
    M.icons = require "icons.nerd_font"
    M.text_icons = require "icons.text"
    local icon = M["icons"] and M["icons"][kind]
    return icon and icon .. string.rep(" ", padding or 0) or ""
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available # Whether the plugin is available
function M.is_available(plugin)
    local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
    return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Serve a notification with a title of Gavin
---@param msg string The notification body
---@param type? number The type of the notification (:help vim.log.levels)
---@param opts? table The nvim-notify options to use (:help notify-options)
function M.notify(msg, type, opts)
    vim.schedule(function() vim.notify(msg, type, M.extend_tbl({ title = "Gavin" }, opts)) end)
end

-- Close every floating window
M.close_floating_windows = function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == 'win' then
            vim.api.nvim_win_close(win, false)
        end
    end
end

-- Mini.ai indent text object
-- For "a", it will include the non-whitespace line surrounding the indent block.
-- "a" is line-wise, "i" is character-wise.
function M.ai_indent(ai_type)
    local spaces = (" "):rep(vim.o.tabstop)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local indents = {} ---@type {line: number, indent: number, text: string}[]

    for l, line in ipairs(lines) do
        if not line:find("^%s*$") then
            indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
        end
    end

    local ret = {} ---@type (Mini.ai.region | {indent: number})[]

    for i = 1, #indents do
        if i == 1 or indents[i - 1].indent < indents[i].indent then
            local from, to = i, i
            for j = i + 1, #indents do
                if indents[j].indent < indents[i].indent then
                    break
                end
                to = j
            end
            from = ai_type == "a" and from > 1 and from - 1 or from
            to = ai_type == "a" and to < #indents and to + 1 or to
            ret[#ret + 1] = {
                indent = indents[i].indent,
                from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
                to = { line = indents[to].line, col = #indents[to].text },
            }
        end
    end

    return ret
end

-- taken from MiniExtra.gen_ai_spec.buffer
function M.ai_buffer(ai_type)
    local start_line, end_line = 1, vim.fn.line("$")
    if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
    end

    local to_col = math.max(vim.fn.getline(end_line):len(), 1)
    return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

---source: dropbar.nvim
---Check if cursor is in range
---@param cursor integer[] cursor position (line, character); (1, 0)-based
---@param range lsp_range_t 0-based range
---@return boolean
function M.cursor_in_range(cursor, range)
    local cursor0 = { cursor[1] - 1, cursor[2] }
    return (
            cursor0[1] > range.start.line
            or (
                cursor0[1] == range.start.line
                and cursor0[2] >= range.start.character
            )
        )
        and (
            cursor0[1] < range['end'].line
            or (
                cursor0[1] == range['end'].line
                and cursor0[2] <= range['end'].character
            )
        )
end


return M
