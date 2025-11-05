
local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
    s("sort", {
        t("sort("), i(1), t(".begin(), "),
        rep(1), t(".end());"), -- Note the change here
        i(0)
    }),
    -- more snippets
}
