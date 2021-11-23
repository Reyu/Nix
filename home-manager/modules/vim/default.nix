{ config, pkgs, flake-inputs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ rope jedi ];
    plugins = with pkgs.vimPlugins; [
      # General
      {
        plugin = vim-solarized8;
        config = ''
          set termguicolors
          colorscheme solarized8
        '';
      }
      {
        plugin = tmux-navigator;
        config = ''
          " Disable tmux navigator when zooming the Vim pane
          let g:tmux_navigator_disable_when_zoomed = 1
          let g:tmux_navigator_no_mappings = 1
          nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
          nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
          nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
          nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
          nnoremap <silent> <A-p> :TmuxNavigatePrevious<cr>

          " Terminal exits
          tnoremap <silent> <A-h> <C-\><C-n>:TmuxNavigateLeft<CR>
          tnoremap <silent> <A-j> <C-\><C-n>:TmuxNavigateDown<CR>
          tnoremap <silent> <A-k> <C-\><C-n>:TmuxNavigateUp<CR>
          tnoremap <silent> <A-l> <C-\><C-n>:TmuxNavigateRight<CR>
        '';
      }
      {
        plugin = vim-lion;
        config = ''
          let g:lion_squeeze_spaces = 1
        '';
      }
      {
        plugin = telescope-nvim;
        config = ''
          nnoremap <Leader>tt :Telescope
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          nnoremap <Leader><Leader>b <cmd>Telescope buffers<cr>
          nnoremap <Leader><Leader>m <cmd>Telescope marks<cr>
          nnoremap <Leader><Leader>q <cmd>Telescope quickfix<cr>
          nnoremap <Leader><Leader>l <cmd>Telescope loclist<cr>
          nnoremap <Leader><Leader>s <cmd>Telescope spell_suggest<cr>
        '';
      }
      popup-nvim
      plenary-nvim
      {
        plugin = telescope-hoogle;
        config = ''
          lua require("telescope").load_extension("hoogle")
        '';
      }
      {
        plugin = galaxyline-nvim;
        config = ''
          lua require 'reyu/galaxyline'
        '';
      }
      nvim-web-devicons
      {
        plugin = vimwiki;
        config = ''
          let g:vimwiki_list = [{'path': '~/Notes', 'syntax': 'markdown', 'ext': '.md'}]
        '';
      }

      # Must have T.Pope plugins
      vim-capslock
      vim-commentary
      vim-dispatch
      # vim-dotenv
      vim-eunuch
      vim-fugitive
      vim-obsession
      vim-projectionist
      vim-repeat
      vim-rhubarb
      vim-speeddating
      vim-surround
      vim-tbone
      vim-unimpaired

      # Completion
      {
        plugin = nvim-lspconfig;
        config = ''
        lua require('reyu/lsp_config')
        '';
      }
      {
        plugin = nvim-cmp;
        config = ''
        lua require('reyu/cmp')
        '';
      }
      cmp-nvim-lsp
      cmp-buffer

      # Snippets
      ultisnips

      # Filetypes
      vim-polyglot
      vim-pandoc
      {
        plugin = vim-pandoc-after;
        config = ''let g:pandoc#after#modules#enabled = ["ultisnips"]'';
      }
      vim-pandoc-syntax

      # Debugging
      {
        plugin = nvim-dap;
        config = ''
          nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
          nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
          nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
          nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
          nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
          nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
          nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
          nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
          nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
          lua require('reyu/dap')
        '';
      }
      {
        plugin = nvim-dap-ui;
        config = ''
          lua require('dapui').setup()
          nnoremap <silent> <Leaduer>du :lua require'dapui'.toggle()<CR>
        '';
      }
      telescope-dap-nvim
      nvim-dap-virtual-text
    ];
    extraPackages = with pkgs; [
      # Language servers
      rnix-lsp
      terraform-ls
      nodePackages.bash-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      # Linters
      shellcheck
      yamllint
      ansible-lint
      nix-linter
      nixpkgs-lint
      sqlint
      # Formatters
      luaformatter
      shfmt
      nixfmt
    ];
    extraConfig = ''
      " General Settings {{{
      " Return cursor to last position
      autocmd BufReadPost * silent! normal! g`"zv

      " Don't use the mouse. Ever.
      set mouse=

      " Turn on Mode Lines
      set modeline modelines=3

      " Configure line numbers
      set number norelativenumber

      " Configure tab preferences
      set tabstop=4 shiftwidth=0 expandtab

      " Ignore case in searching...
      set ignorecase
      " ...except if search string contains uppercase
      set smartcase

      " Split windows below, or to the right of, the current window
      set splitbelow splitright

      " Keep some context at screen edges
      set scrolloff=5 sidescrolloff=5

      " Tell Vim which characters to show for expanded TABs,
      " trailing whitespace, and end-of-lines. VERY useful!
      if &listchars ==# 'eol:$'
        set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
      endif
      set list                " Show problematic characters.

      " Also highlight all tabs and trailing whitespace characters.
      highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
      " match ExtraWhitespace /\s\+$\|\t/
      " }}}

      " Files, backups and undo {{{
      " Keep backups in cache folder, so as not to clutter filesystem.
      set backup backupdir=~/.cache/nvim/backup,~/.cache/vim/backup,.
      set undofile undodir=~/.cache/nvim/undo,~/.cache/vim/undo,.
      set directory=~/.cache/nvim/other,~/.cache/vim/other,.

      " Don't need backups for tmp files (usually sudo -e)
      augroup init
        autocmd BufRead,BufEnter /var/tmp/* set nobackup noundofile nowritebackup
      augroup END
      " }}}

      autocmd BufWritePost package.yaml call Hpack()
      function Hpack()
        let err = system('hpack ' . expand('%'))
        if v:shell_error
          echo err
        endif
      endfunction
    '';
  };
  xdg.configFile = { "nvim/lua" = { source = ./lua; }; };
  home.file = {
    # We just want the directories, file contents doesn't matter.
    nvimBackup = {
      text = "";
      target = ".cache/nivm/backup/.keep";
    };
    nvimUndo = {
      text = "";
      target = ".cache/nivm/undo/.keep";
    };
    nvimSwap = {
      text = "";
      target = ".cache/nivm/swap/.keep";
    };
  };
}
