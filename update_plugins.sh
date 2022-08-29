#! /usr/bin/env bash
nix flake lock \
    --commit-lock-file \
    --update-input cmp-conventionalcommits \
    --update-input cmp-dap \
    --update-input cmp-nvim-lsp-signature-help \
    --update-input firenvim \
    --update-input neosolarized-nvim \
    --update-input neotest \
    --update-input neotest-python \
    --update-input neotest-vim-test \
    --update-input netman \
    --update-input nvim-treesitter-endwise \
    --update-input nvim-ufo \
    --update-input one-small-step-for-vimkind \
    --update-input persistence-nvim \
    --update-input promise-async \
    --update-input telescope-hoogle \
    --update-input treesitter-playground \
    --update-input vim-solarized8 \
    "$@"
