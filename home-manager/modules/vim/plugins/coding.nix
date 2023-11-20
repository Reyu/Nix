{ pkgs, ... }: with pkgs.vimPlugins; [
  { plugin = friendly-snippets; }
  {
    plugin = luasnip;
    type = "lua";
    config = ''
      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip').setup({history = true, delete_check_events = 'TextChanged'})
    '';
  }

  cmp-buffer
  cmp-calc
  cmp-dap
  cmp-emoji
  cmp-git
  cmp-nvim-lsp
  cmp-path
  cmp-tmux
  cmp_luasnip
  cmp-under-comparator
  lspkind-nvim
  {
    plugin = nvim-cmp;
    type = "lua";
    config = ''
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
          snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
          window = {
              completion = cmp.config.window.bordered(),
              documenation = cmp.config.window.bordered()
          },
          preselect = cmp.PreselectMode.None,
          mapping = cmp.mapping.preset.insert({
              ['<Tab>'] = cmp.mapping(function(fallback)
                  if luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                  else
                      fallback()
                  end
              end, {'i', 's'}),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                  else
                      fallback()
                  end
              end, {'i', 's'}),
              ['<C-b>'] = cmp.mapping(function(fallback)
                  if luasnip.choice_active() then
                      luasnip.change_choice(-1)
                  elseif cmp.visible() then
                      cmp.mapping.scroll_docs(-4)
                  else
                      fallback()
                  end
              end, {'i', 's'}),
              ['<C-f>'] = cmp.mapping(function(fallback)
                  if luasnip.choice_active() then
                      luasnip.change_choice(1)
                  elseif cmp.visible() then
                      cmp.mapping.scroll_docs(4)
                  else
                      fallback()
                  end
              end, {'i', 's'}),
              ['<C-Space>'] = cmp.mapping.complete({}),
              ['<C-e>'] = cmp.mapping.abort(),
              ["<C-n>"] = cmp.mapping.select_next_item({
                  behavior = cmp.SelectBehavior.Insert
              }),
              ['<C-p>'] = cmp.mapping.select_prev_item({
                  behavior = cmp.SelectBehavior.Insert
              }),
              ['<CR>'] = cmp.mapping.confirm({select = false})
          }),
          sources = cmp.config.sources({
              {name = 'luasnip'}, {
                  name = 'nvim_lsp',
                  entry_filter = function(entry)
                      return
                          require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~=
                              'Text'
                  end
              }
          }, {{name = 'buffer'}, {name = 'path'}}, {
              {name = 'neorg'}, {name = 'calc'}, {name = 'emoji'}
          }),
          formatting = {
              format = function(entry, vim_item)
                  if vim.tbl_contains({'path'}, entry.source.name) then
                      local icon, hl_group = require('nvim-web-devicons').get_icon(
                                                 entry:get_completion_item().label)
                      if icon then
                          vim_item.kind = icon
                          vim_item.kind_hl_group = hl_group
                          return vim_item
                      end
                  end
                  return require('lspkind').cmp_format({with_text = true})(entry,
                                                                           vim_item)
              end
          },
          sorting = {
              comparators = {
                  cmp.config.compare.offset, cmp.config.compare.exact,
                  cmp.config.compare.score, require("cmp-under-comparator").under,
                  cmp.config.compare.sort_text, cmp.config.compare.kind,
                  cmp.config.compare.length, cmp.config.compare.order
              }
          },
          view = {entries = {name = 'custom', selection_order = 'near_cursor'}},
          experimental = {ghost_text = {hl_group = "LspCodeLens"}}
      })
      cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({{name = 'cmp_git'}, {name = 'cmp_luasnip'}},
                                       {{name = 'cmp_path'}, {name = 'buffer'}})
      })
    '';
  }
  {
    plugin = neogen;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd neogen')
          local neogen = require('neogen')
          neogen.setup({snippet_engine = "luasnip"})
          vim.keymap.set('n', '<LocalLeader>nn', neogen.generate,
                         {desc = 'Generate annotation'})
          vim.keymap.set('n', '<LocalLeader>nc',
                         function() neogen.generate({type = 'class'}) end,
                         {desc = 'Generate class annotation'})
          vim.keymap.set('n', '<LocalLeader>nf',
                         function() neogen.generate({type = 'func'}) end,
                         {desc = 'Generate function annotation'})
      end
    '';
  }
]
