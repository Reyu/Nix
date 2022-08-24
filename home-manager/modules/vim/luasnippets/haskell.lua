local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda

local rec_field
rec_field = function()
    return sn(
        nil,
        c(1, {
            t(""),
            sn(nil, {
                t({ "", "    , " }),
                i(1, "field"),
                t(" :: "),
                i(2, "Text"),
                d(3, rec_field, {}),
            }),
        })
    )
end

ls.add_snippets("haskell", {
    s({ trig = "import", name = "Import" }, {
        t("import "),
        c(2, { t("          "), t("qualified ") }),
        i(1, "Data.Text"),
        c(3, { t(""), sn(nil, { t(" as "), i(1, "T") }) }),
        c(4, { t(""), sn(nil, { t(" ("), i(1), t(")") }) }),
    }),
    s({ trig = "data", name = "Data Type", dscr = "Create a new Data type with an arbitrary number of fields" }, {
        t("data "),
        i(1, "Type"),
        t(" = "),
        dl(2, l._1, 1),
        t({ "", "    { " }),
        i(3, "field"),
        t(" :: "),
        i(4, "Text"),
        d(5, rec_field, {}),
        t({ "", "    }"}),
    }),
    s({ trig = "deriving", name = "Deriving Clause" }, {
        t("  deriving "),
        c(1, {
            t(""),
            t("stock "),
            t("anyclass "),
            sn(nil, { r(1, "deriving_class"), t(" ") }),
        }),
        t("("),
        i(2, "Show, Eq"),
        t(")"),
    })
}, {
    key = "haskell",
})
