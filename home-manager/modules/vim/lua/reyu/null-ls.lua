local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.completion.luasnip, null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace
    }
})

-- TODO: Add filetype hooks for loading other formatters
-- OR: implement direnv/nix shell loading of vimrc files
