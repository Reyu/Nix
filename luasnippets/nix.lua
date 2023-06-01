local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("nix", {
  s({trig = "plugin", name = "Neovim Plugin"}, {
    t({'{', '  plugin = '}),
    i(1, 'pkgs.vimPlugins.PlugName'),
    t({';', '  type = "'}),
    c(2, { t('lua'), t('viml'), t('teal'), t('fennel') }),
    t({';', "  config =''", ''}),
    i(3),
    t({'', "'';", '}'})
  })
}, {key = "home-manager"})
