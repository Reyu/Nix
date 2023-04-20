local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta

local hlgroup = vim.api.nvim_get_hl_id_by_name("DiagnosticHint")

local virtText = function(txt)
    return {node_ext_opts = {active = {virt_text = {{txt, hlgroup}}}}}
end

ls.add_snippets("lua", {
    s({trig = "register", name = "Which-Key Register"}, fmta([[
            require("which-key").register({
                <key>
            }, {mode = <mode><prefix> })
            ]], {
        key = i(0),
        mode = c(1, {t('"n"'), t('"v"'), t('"t"'), t('"x"'), i(nil)}),
        prefix = c(2, {
            t("", virtText("Add prefix?")), t(", prefix = \"<Leader>\""),
            t(", prefix = \"<Space>\""),
            sn(nil, {t(", prefix = \""), i(1, "<Leader>"), t("\"")})
        })
    })), s({trig = "group", name = "Which-Key Group"}, fmta([[
            <lhs> = {
                name = "<name>",
                <next>
            },
            ]], {lhs = i(1), name = i(2), next = i(0)})),
    s({trig = "key", name = "Which-Key Keybind"}, fmta([[
            <lhs> = {
                <rhs>,
                "<help>"
            },
            ]], {
        lhs = i(1),
        rhs = c(2, {
            sn(nil, {t("function() "), i(1), t(" end")}),
            sn(nil, {t('"'), i(1), t('"')})
        }),
        help = i(3, "Description")
    }))
}, {key = "which-key"})
