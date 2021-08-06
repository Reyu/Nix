{ config, pkgs, ... }:

 let
   plugins = pkgs.callPackage ../configs/nvim/custom-plugins.nix {};
 in
{
  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;

    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [
      rope
      jedi
    ];
    plugins = with pkgs.vimPlugins // plugins; [
      # General
      { plugin = vim-solarized8;
        config = ''
          set termguicolors
          colorscheme solarized8
        '';
      }
      { plugin = tmux-navigator;
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
      { plugin = vim-lion;
        config = "let g:lion_squeeze_spaces = 1";
      }
      { plugin = telescope-nvim;
        config = ''
        nnoremap <silent> <Leader>ts :Telescope builtins<CR>
        nnoremap <silent> <Leader>ff :Telescope find_files<CR>
        nnoremap <silent> <Leader>fg :Telescope git_files<CR>
        nnoremap <silent> <Leader>fb :Telescope file_browser<CR>
        nnoremap <silent> <Leader><Leader>b :Telescope buffers<CR>
        nnoremap <silent> <Leader><Leader>m :Telescope marks<CR>
        nnoremap <silent> <Leader><Leader>t :Telescope treesitter<CR>
        nnoremap <silent> <Leader><Leader>q :Telescope quickfix<CR>
        nnoremap <silent> <Leader><Leader>l :Telescope loclist<CR>
        nnoremap <silent> <Leader><Leader>s :Telescope spell_suggest<CR>
        '';
      }
      { plugin = galaxyline-nvim;
        config = ''
          lua require 'reyu/galaxyline'
        '';
      }
      nvim-web-devicons

      # Must have T.Pope plugins
      vim-commentary
      vim-dispatch
      vim-eunuch
      vim-fugitive
      vim-obsession
      vim-projectionist
      vim-repeat
      vim-surround
      vim-unimpaired

      # Completion
      { plugin = deoplete-nvim;
        config = ''
          " let g:deoplete#enable_at_startup = 0
          " call deoplete#custom#option('num_processes', 16)
          call deoplete#custom#var('omni', 'input_patterns', {
            \ 'pandoc': '@'
            \})
        '';
      }
      deoplete-lsp
      deoplete-emoji
      deoplete-zsh
      { plugin = nvim-lspconfig;
        config = "lua require('reyu.lsp_config')";
      }
      { plugin = nvim-treesitter;
        config = ''
          lua require('reyu/treesitter_config');
          set foldmethod=expr
          set foldexpr=nvim_treesitter#foldexpr()
        '';
      }

      # Snippets
      { plugin = vim-vsnip;
        config = ''
          " Expand
          imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
          smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

          " Expand or jump
          imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
          smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

          " Jump forward or backward
          imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
          smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
          imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
          smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

          " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
          " See https://github.com/hrsh7th/vim-vsnip/pull/50
          nmap        s   <Plug>(vsnip-select-text)
          xmap        s   <Plug>(vsnip-select-text)
          nmap        S   <Plug>(vsnip-cut-text)
          xmap        S   <Plug>(vsnip-cut-text)
        '';
      }
      vim-vsnip-integ

       # Filetypes
       vim-polyglot
       vim-pandoc

      { plugin = vim-pandoc-after;
        config = "let g:pandoc#after#modules#enabled = ['neosnippet']";
      }
      vim-pandoc-syntax

      # Debugging
      { plugin = nvim-dap;
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
      { plugin = nvim-dap-ui;
        config = ''
        lua require('dapui').setup()
        nnoremap <silent> <Leaduer>du :lua require'dapui'.toggle()<CR>
        '';
      }
      nvim-dap-virtual-text
      telescope-dap-nvim
    ];
    extraPackages = with pkgs; [
      # for treesitter
      gcc
      tree-sitter
      # Language servers
      terraform-ls
      nodePackages.bash-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
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
  xdg.configFile = {
    "nvim/lua" = {
      source = ../configs/nvim/lua;
    };
  };
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
