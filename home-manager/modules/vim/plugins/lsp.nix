{ pkgs, ... }:
with pkgs.vimPlugins; [
  {
    plugin = nvim-lspconfig;
    type = "lua";
    config = ''
            local lspconfig = require('lspconfig')

            local function previewLocationCallback(_, result)
              if result == nil or vim.tbl_isempty(result) then return nil end
              vim.lsp.util.preview_location(result[1], {border = 'rounded'})
            end

            local function peekDefinition(bufnr)
              local params = vim.lsp.util.make_position_params(0, 'utf-16')
              return vim.lsp.buf_request(bufnr, 'textDocument/definition', params,
                  previewLocationCallback)
            end

            local function genOpts(desc, bufnr)
              return {
                desc = desc,
                buffer = bufnr,
                noremap = true,
                silent = true
              }
            end

            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              desc = 'LSP Keybinds',
              callback = function(event)
                vim.keymap.set('n', 'K', function()
                    local winid = require('ufo').peekFoldedLinesUnderCursor()
                    if not winid then vim.lsp.buf.hover() end
                  end,
                  genOpts('Show hover menu', event.buf)
                )
                vim.keymap.set('n', '<LocalLeader>p', peekDefinition, genOpts('Peek definition', event.buf))
                vim.keymap.set('n', '<LocalLeader>h', function() require('haskell-tools').hoogle.hoogle_signature() end, genOpts('Hoogle Signature', event.buf))
                vim.keymap.set('n', '<LocalLeader>ca', vim.lsp.buf.code_action, genOpts('Run code actions', event.buf))
                vim.keymap.set('n', '<LocalLeader>cl', vim.lsp.codelens.run, genOpts('Run Codelens', event.buf))
                vim.keymap.set({'n', 'x'}, '<LocalLeader>f', function() vim.lsp.buf.format({async = true}) end, genOpts('Format', event.buf))
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, genOpts('Go to definition', event.buf))
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, genOpts('Go to declaration', event.buf))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, genOpts('Go to implementation', event.buf))
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, genOpts('Go to type definition', event.buf))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, genOpts('Go to references', event.buf))
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, genOpts('Signature help', event.buf))
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, genOpts('Open diagnostic float', event.buf))
                vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, genOpts('Go to previous diagnostic', event.buf))
                vim.keymap.set('n', ']d', vim.diagnostic.goto_next, genOpts('Go to next diagnostic', event.buf))
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, genOpts('Add workspace folder', event.buf))
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, genOpts('Remove workspace folder', event.buf))
                vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_fjlders())) end,
      	    genOpts('List workspace folders', event.buf))
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, genOpts('Rename', event.buf))
              end
            })

            -- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
            --   capabilities = {
            --     textDocument = {
            --       foldingRange = {dynamicRegistration = false, lineFoldingOnly = true}
            --     }
            --   }
            -- })
            lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
              'force',
              lspconfig.util.default_config.capabilities,
              require('cmp_nvim_lsp').default_capabilities()
            )

            lspconfig.bashls.setup({})
            lspconfig.dockerls.setup({})
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {runtime = 'LuaJIT'},
                diagnostic = { globals = {'vim'}},
                workspace = {library = {vim.env.VIMRUNTIME}}
              }
            })
            lspconfig.rnix.setup({})
            lspconfig.jsonls.setup({
                -- lazy-load schemastore when needed
                on_new_config = function(new_config)
                    new_config.settings.json.schemas =
                        new_config.settings.json.schemas or {}
                    vim.list_extend(new_config.settings.json.schemas,
                                    require("schemastore").json.schemas())
                end,
                settings = {json = {format = {enable = true}, validate = {enable = true}}}
            })
            lspconfig.yamlls.setup({settings = {yaml = {keyOrdering = false}}})
    '';
  }
  {
    plugin = lsp_lines-nvim;
    type = "lua";
    config = ''
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_text = false })
      vim.keymap.set('n', '<LocalLeader>l', require("lsp_lines").toggle, { desc = "Toggle LSP Lines" })
    '';
  }
  {
    plugin = haskell-tools-nvim;
    type = "lua";
    config = ''
      local haskell_tools = require('haskell-tools')

      ---@type HTOpts
      vim.g.haskell_tools = {
        ---@type ToolsOpts
        tools = {
          hover = {stylize_markdown = true},
          definition = {hoogle_signature_fallback = true},
          repl = {handler = 'toggleterm'},
        },
        ---@type HaskellLspClientOpts
        hls = {
          on_attach = function(client, bufnr)
            map('n', '<leader>ca', vim.lsp.codelens.run, {desc = "Run Codelens"}, bufnr)
            map('n', '<leader>hs', haskell_tools.hoogle.hoogle_signature, {desc = "Hoogle Signature"}, bufnr)
            map('n', '<leader>ea', haskell_tools.lsp.buf_eval_all, {desc = "Evaluate Buffer"}, bufnr)
            map('n', '<leader>rr', haskell_tools.repl.toggle, {desc = 'Open REPL for package'}, bufnr)
            map('n', '<leader>rf', function() haskell_tools.repl.toggle(vim.api.nvim_buf_get_name(0)) end, {desc = 'Toggle REPL for buffer'}, bufnr)
            map('n', '<leader>rq', haskell_tools.repl.quit, {desc = 'Quit REPL'}, bufnr)
            end,
        },
        ---@type HTDapOpts
        dap = {
          -- ...
        },
      }
    '';
  }
]
