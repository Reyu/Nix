{ pkgs, ... }:
with pkgs.vimPlugins; [
  nvim-lspconfig
  {
    plugin = lsp-zero-nvim;
    type = "lua";
    config = ''
      local function map(mode, lhs, rhs, extra_opts, bufnr)
          local opts = vim.tbl_extend('keep', extra_opts or {}, {
            buffer = bufnr,
            noremap = true,
            silent = true
          })
          vim.keymap.set(mode, lhs, rhs, opts)
      end

      local function previewLocationCallback(_, result)
          if result == nil or vim.tbl_isempty(result) then return nil end
          vim.lsp.util.preview_location(result[1], {border = 'rounded'})
      end

      local function peekDefinition(bufnr)
          local params = vim.lsp.util.make_position_params(0, 'utf-16')
          return vim .lsp.buf_request(bufnr, 'textDocument/definition', params,
                                      previewLocationCallback)
      end

      local lsp = require('lsp-zero').preset({
        name = 'system-lsp',
        manage_nvim_cmp = false,
      })

      lsp.on_attach(function(_, bufnr)
          lsp.default_keymaps({buffer = bufnr, omit = {'K'}})

          map({'n', 'x'}, 'gq', function()
              vim.lsp.buf.format({async = false, timeout_ms = 10000})
          end, {desc = 'Format Buffer/Selection'}, bufnr)
          map('n', 'K', function()
              local winid = require('ufo').peekFoldedLinesUnderCursor()
              if not winid then vim.lsp.buf.hover() end
          end, {desc = 'Show hover menu'}, bufnr)
          map('n', '<LocalLeader>p', peekDefinition,
              {desc = 'Peek definition'}, bufnr)
          map('n', '<LocalLeader>h', function()
              require('haskell-tools').hoogle.hoogle_signature()
          end, {desc = 'Hoogle Signature'}, bufnr)
          map('n', '<LocalLeader>ca', vim.lsp.buf.code_action,
              {desc = 'Run code actions'}, bufnr)
          map('n', '<LocalLeader>cl', vim.lsp.codelens.run,
              {desc = 'Run Codelens'}, bufnr)
      end)

      lsp.set_server_config({
          capabilities = {
              textDocument = {
                  foldingRange = {
                      dynamicRegistration = false,
                      lineFoldingOnly = true
                  }
              }
          }
      })

      lsp.setup_servers({
          'bashls', 'dockerls', 'rnix', 'terraformls',
          force = true
      })
      lsp.configure('jsonls', {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
              new_config.settings.json.schemas =
                  new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas,
                              require("schemastore").json.schemas())
          end,
          settings = {json = {format = {enable = true}, validate = {enable = true}}}
      })
      lsp.configure('yamlls', {settings = {yaml = {keyOrdering = false}}})

      lsp.setup()
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
    plugin = ale;
    type = "viml";
    config = ''
      let g:ale_disable_lsp = 1
      let g:ale_use_neovim_diagnostics_api = 1
      let g:ale_set_loclist = 0
      let g:ale_fixers = { 'nix': [ 'nixfmt' ] }
    '';
  }
  {
    plugin = haskell-tools-nvim;
    type = "lua";
    config = ''
      local haskell_tools = require('haskell-tools')
      local hls_lsp = require('lsp-zero').build_options('hls', {})

      local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp', {clear = true})
      vim.api.nvim_create_autocmd('FileType', {
          group = hls_augroup,
          pattern = {'haskell'},
          callback = function(ev)
              haskell_tools.start_or_attach({
                  hls = {
                      capabilities = hls_lsp.capabilities,
                      on_attach = function(_, bufnr)
                          map('n', '<leader>ca', vim.lsp.codelens.run,
                              {desc = "Run Codelens"}, bufnr)
                          map('n', '<leader>hs',
                              haskell_tools.hoogle.hoogle_signature,
                              {desc = "Hoogle Signature"}, bufnr)
                          map('n', '<leader>ea', haskell_tools.lsp.buf_eval_all,
                              {desc = "Evaluate Buffer"}, bufnr)
                      end
                  },
                  tools = {
                      hover = {stylize_markdown = true},
                      definition = {hoogle_signature_fallback = true}
                  }
              })
              haskell_tools.dap.discover_configurations(ev.buf)
              map('n', '<leader>rr', haskell_tools.repl.toggle,
                  {desc = 'Open REPL for package'}, ev.buf)
              map('n', '<leader>rf', function()
                  haskell_tools.repl.toggle(vim.api.nvim_buf_get_name(0))
              end, {desc = 'Toggle REPL for buffer'}, ev.buf)
              map('n', '<leader>rq', haskell_tools.repl.quit, {desc = 'Quit REPL'},
                  ev.buf)
          end
      })
    '';
  }
]
