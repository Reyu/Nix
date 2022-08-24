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

local hlgroup = vim.api.nvim_get_hl_id_by_name("DiagnosticHint")

local rec_field
rec_field = function(args, _, _, user_args1)
    local prefix
    if #(args) > 0 then
        prefix = args[1][1]
    else
        prefix = user_args1
    end
    return sn(
        nil,
        c(1, {
            t("}", { node_ext_opts = { active = { virt_text = { { "Add another field?", hlgroup } } } } }),
            sn(nil, {
                t(", " .. prefix),
                i(1),
                t(" :: "),
                i(2, "Text"),
                t({ "", "    " }),
                d(3, rec_field, {}, { user_args = { prefix } }),
            }),
        }, { restore_cursor = true })
    )
end

ls.add_snippets("haskell", {
    s({ trig = "import", name = "Import" }, {
        t("import "),
        c(
            2,
            { t("          "), t("qualified ") },
            { node_ext_opts = { active = { virt_text = { { "Qualify import?", hlgroup } } } } }
        ),
        i(1, "Data.Text"),
        c(
            3,
            { t(""), sn(nil, { t(" as "), i(1, "T") }) },
            { node_ext_opts = { active = { virt_text = { { "Rename import?", hlgroup } } } } }
        ),
        c(
            4,
            { t(""), sn(nil, { t(" ("), i(1), t(")") }) },
            { node_ext_opts = { active = { virt_text = { { "Restrict scope?", hlgroup } } } } }
        ),
    }),
    s({ trig = "data", name = "Data Type", dscr = "Create a new Data type with an arbitrary number of fields" }, {
        t("data "),
        i(1, "Name"),
        t(" = "),
        dl(2, l._1, 1),
        t({ "", "    { " }),
        c(
            3,
            { l(l._1:lower(), 1), l('_' .. l._1:lower(), 1), i(nil)},
            { node_ext_opts = { active = { virt_text = { { "Select a prefix", hlgroup}}}}}
        ),
        i(4, "Id"),
        t(" :: "),
        i(5, "Text"),
        t({ "", "    " }),
        d(6, rec_field, { 3 }),
    }),
    s({ trig = "deriving", name = "Deriving Clause" }, {
        t("  deriving "),
        c(1, {
            t(""),
            t("stock "),
            t("anyclass "),
            sn(nil, { r(1, "deriving_class"), t(" ") }),
        }, { node_ext_opts = { active = { virt_text = { { "Set Deriving Class", hlgroup } } } } }),
        t("("),
        i(2, "Show, Eq"),
        t(")"),
    }),
}, {
    key = "haskell",
})
