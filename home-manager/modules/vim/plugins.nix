{ config, pkgs, ... }: with pkgs.vimPlugins; let
  minimal = config.programs.neovim.minimal;
in
[
  # Telescope
  telescope-nvim
  telescope-dap-nvim
  telescope-manix
  telescope-undo-nvim
  telescope_hoogle
  telescope-ui-select-nvim
  { name = "telescope-fzf-native.nvim"; path = telescope-fzf-native-nvim; }

  # Coding
  { name = "LuaSnip"; path = luasnip; }
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
  nvim-cmp
  neogen

  # Diagnostic
  neotest
  neotest-python
  neotest-haskell
  trouble-nvim
  nvim-dap
  nvim-dap-python
  nvim-dap-ui

  # Editor
  neo-tree-nvim
  neoscroll-nvim
  nvim-ufo
  todo-comments-nvim

  # Extra
  vimtex
  nvim-ts-context-commentstring
  neorg
  nvim-projector
  { name = "mini.ai"; path = mini-nvim; }
  { name = "mini.align"; path = mini-nvim; }
  { name = "mini.bracketed"; path = mini-nvim; }
  { name = "mini.bufremove"; path = mini-nvim; }
  { name = "mini.comment"; path = mini-nvim; }
  { name = "mini.indentscope"; path = mini-nvim; }
  { name = "mini.pairs"; path = mini-nvim; }
  { name = "mini.surround"; path = mini-nvim; }
  { name = "mini.misc"; path = mini-nvim; }

  # Git
  gitsigns-nvim
  vim-fugitive
  neogit
  octo-nvim

  # Terminal
  nvterm
  nvim-terminal-lua
  toggleterm-nvim

  # UI
  zen-mode-nvim
  twilight-nvim
  nvim-notify
  noice-nvim
  bufresize-nvim
  alpha-nvim
  indent-blankline-nvim
  lualine-nvim
  edgy-nvim

  # General / Dependencies
  github-nvim-theme
  which-key-nvim
  nvim-treesitter.withAllGrammars
  nvim-treesitter-context
  nvim-treesitter-textobjects
  nvim-treesitter-endwise
  playground
  vim-repeat
  nvim-web-devicons
  plenary-nvim
  nui-nvim
  promise-async
] ++ (if minimal then [ ] else [
  # Coding
  { name = "lspkind.nvim"; path = lspkind-nvim; }

  # Extra
  firenvim

  # LSP
  nvim-lspconfig
  lsp_lines-nvim
  haskell-tools-nvim
])
