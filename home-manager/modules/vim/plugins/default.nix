{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = github-nvim-theme;
    type = "lua";
    config = ''
      local transparent = not vim.g.started_by_firenvim
      require('github-theme').setup({options = {transparent = transparent}})
      vim.cmd([[ colorscheme github_dark ]])
    '';
  }
  {
    plugin = which-key-nvim;
    type = "lua";
    config = ''
      require('which-key').setup({
          plugins = {spelling = {enabled = true}},
          window = {
              border = 'single',
              margin = {5, 10, 5, 10},
              padding = {1, 2, 1, 2}
          }
      })
    '';
  }
  {
    plugin = nvim-treesitter.withAllGrammars;
    type = "lua";
    config = ''
      require('nvim-treesitter.configs').setup({
            highlight = {enable = true},
            indent = {enable = true, disable = {"python"}},
            context_commentstring = {enable = true, enable_autocmd = false},
            endwise = {enable = true},
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>"
                }
            },
            textobjects = {
                swap = {
                    enable = true,
                    swap_next = {["<leader>a"] = "@parameter.inner"},
                    swap_previous = {["<leader>A"] = "@parameter.inner"}
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    peek_definition_code = {
                        ['<localleader>df'] = '@function.outer',
                        ['<localleader>dF'] = '@class.outer'
                    }
                },
                select = {
                    enable = true,
                    keymaps = {
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner'
                    },
                    include_surrounding_whitespace = true
                }
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        })
    '';
  }
  {
    plugin = nvim-treesitter-context;
    type = "lua";
    config = ''
      require('treesitter-context').setup({
          enable = true,
          max_lines = 0,
          trim_scope = 'outer',
          patterns = {
              default = {
                  'class', 'function', 'method', 'for', 'while', 'if', 'switch',
                  'case'
              }
          }
      })
    '';
  }
  { plugin = nvim-treesitter-textobjects; }
  { plugin = nvim-treesitter-endwise; }
  { plugin = playground; }
  { plugin = vim-repeat; }
  { plugin = nvim-web-devicons; }
  { plugin = plenary-nvim; }
  { plugin = nui-nvim; }
  { plugin = promise-async; }
] ++ import ./telescope.nix { inherit pkgs; }
  ++ import ./ui.nix { inherit pkgs; }
  ++ import ./terminal.nix { inherit pkgs; }
  ++ import ./editor.nix { inherit pkgs; }
  ++ import ./coding.nix { inherit pkgs; }
  ++ import ./diagnostics.nix { inherit pkgs; }
  ++ import ./extra.nix { inherit pkgs; }
  ++ import ./git.nix { inherit pkgs; }
  ++ import ./lsp.nix { inherit pkgs; }
