local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fn = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda

local hlgroup = vim.api.nvim_get_hl_id_by_name("DiagnosticHint")

local virtText = function(txt)
    return { node_ext_opts = { active = { virt_text = { { txt, hlgroup } } } } }
end

local rec_field
rec_field = function(args, _, _, user_args1)
    local prefix
    if #args > 0 then
        prefix = args[1][1]
    else
        prefix = user_args1
    end
    return sn(
        nil,
        c(1, {
            t("}", virtText("Add another field?")),
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
    s(
        { trig = "header", name = "Module Header" },
        fmt(
            [[
            {{- |
            Module      :  {moduleName}
            Description :  {summary}
            Copyright   :  (c) {copyright}
            License     :  {license}
            Maintainer  :  {maintainer}
            Stability   :  {stability}
            Portability :  {portability}

            {description}
            -}}
            module {module} (
                ) where

            {done}
            ]],
            {
                module = i(1, "$Header$"),
                moduleName = l(l._1, {1}),
                summary = i(2, "Summary"),
                copyright = i(3, "20XX Tech Bro Inc."),
                license = c(4, {
                    t("mit", virtText("MIT")),
                    t("afl-3.0", virtText("Academic Free License v3.0")),
                    t("apache-2.0", virtText("Apache license 2.0")),
                    t("artistic-2.0", virtText("Artistic license 2.0")),
                    t("bsl-1.0", virtText("Boost Software License 1.0")),
                    t("bsd-2-clause", virtText('BSD 2-clause "Simplified" license')),
                    t("bsd-3-clause", virtText('BSD 3-clause "New" or "Revised" license')),
                    t("bsd-3-clause-clear", virtText("BSD 3-clause Clear license")),
                    t("cc", virtText("Creative Commons license family")),
                    t("cc0-1.0", virtText("Creative Commons Zero v1.0 Universal")),
                    t("cc-by-4.0", virtText("Creative Commons Attribution 4.0")),
                    t("cc-by-sa-4.0", virtText("Creative Commons Attribution Share Alike 4.0")),
                    t("wtfpl", virtText("Do What The F*ck You Want To Public License")),
                    t("ecl-2.0", virtText("Educational Community License v2.0")),
                    t("epl-1.0", virtText("Eclipse Public License 1.0")),
                    t("epl-2.0", virtText("Eclipse Public License 2.0")),
                    t("eupl-1.1", virtText("European Union Public License 1.1")),
                    t("agpl-3.0", virtText("GNU Affero General Public License v3.0")),
                    t("gpl", virtText("GNU General Public License family")),
                    t("gpl-2.0", virtText("GNU General Public License v2.0")),
                    t("gpl-3.0", virtText("GNU General Public License v3.0")),
                    t("lgpl", virtText("GNU Lesser General Public License family")),
                    t("lgpl-2.1", virtText("GNU Lesser General Public License v2.1")),
                    t("lgpl-3.0", virtText("GNU Lesser General Public License v3.0")),
                    t("isc", virtText("ISC")),
                    t("lppl-1.3c", virtText("LaTeX Project Public License v1.3c")),
                    t("ms-pl", virtText("Microsoft Public License")),
                    t("mpl-2.0", virtText("Mozilla Public License 2.0")),
                    t("osl-3.0", virtText("Open Software License 3.0")),
                    t("postgresql", virtText("PostgreSQL License")),
                    t("ofl-1.1", virtText("SIL Open Font License 1.1")),
                    t("ncsa", virtText("University of Illinois/NCSA Open Source License")),
                    t("unlicense", virtText("The Unlicense")),
                    t("zlib", virtText("zLib License")),
                    i(nil),
                }),
                maintainer = c(5, {
                    fn(function()
                        local email = io.popen("git config user.email", "r")
                        return email:read()
                    end),
                    i(nil),
                }),
                stability = c(6, {
                    t("unstable"),
                    t("experimental"),
                    t("provisional"),
                    t("stable"),
                    t("frozen"),
                }),
                portability = c(7, {
                    t("portable"),
                    t("non-portable"),
                    i(nil),
                }),
                description = i(8),
                done = i(0),
            }
        )
    ),
    s({ trig = "import", name = "Import" }, {
        t("import "),
        c(2, { t("          "), t("qualified ") }, virtText("Qualify import?")),
        i(1, "Data.Text"),
        c(3, { t(""), sn(nil, { t(" as "), i(1, "T") }) }, virtText("Rename import?")),
        c(4, { t(""), sn(nil, { t(" ("), i(1), t(")") }) }, virtText("Restrict scope?")),
    }),
    s({ trig = "data", name = "Data Type", dscr = "Create a new Data type with an arbitrary number of fields" }, {
        t("data "),
        i(1, "Name"),
        t(" = "),
        dl(2, l._1, 1),
        t({ "", "    { " }),
        c(3, { l(l._1:lower(), 1), l("_" .. l._1:lower(), 1), i(nil) }, virtText("Select a prefix")),
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
        }, virtText("Set Deriving Class")),
        t("("),
        i(2, "Show, Eq"),
        t(")"),
    }),
}, {
    key = "haskell",
})
