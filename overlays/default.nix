{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
final: prev: let
  myVimPlugins = {
    cmp-conventionalcommits     = prev.callPackage ../packages/cmp-conventionalcommits.nix     { inputs = inputs; };
    cmp-dap                     = prev.callPackage ../packages/cmp-dap.nix                     { inputs = inputs; };
    cmp-nvim-lsp-signature-help = prev.callPackage ../packages/cmp-nvim-lsp-signature-help.nix { inputs = inputs; };
    firenvim                    = prev.callPackage ../packages/firenvim.nix                    { inputs = inputs; };
    mind-nvim                   = prev.callPackage ../packages/mind-nvim.nix                   { inputs = inputs; };
    mini-nvim                   = prev.callPackage ../packages/mini-nvim.nix                   { inputs = inputs; };
    neosolarized-nvim           = prev.callPackage ../packages/NeoSolarized-nvim.nix           { inputs = inputs; };
    neotest                     = prev.callPackage ../packages/neotest.nix                     { inputs = inputs; };
    neotest-python              = prev.callPackage ../packages/neotest-python.nix              { inputs = inputs; };
    neotest-vim-test            = prev.callPackage ../packages/neotest-vim-test.nix            { inputs = inputs; };
    netman                      = prev.callPackage ../packages/netman.nix                      { inputs = inputs; };
    nvim-treesitter-endwise     = prev.callPackage ../packages/nvim-treesitter-endwise.nix     { inputs = inputs; };
    nvim-ufo                    = prev.callPackage ../packages/nvim-ufo.nix                    { inputs = inputs; };
    one-small-step-for-vimkind  = prev.callPackage ../packages/one-small-step-for-vimkind.nix  { inputs = inputs; };
    persistence-nvim            = prev.callPackage ../packages/persistence-nvim.nix            { inputs = inputs; };
    promise-async               = prev.callPackage ../packages/promise-async.nix               { inputs = inputs; };
    telescope-hoogle            = prev.callPackage ../packages/telescope-hoogle.nix            { inputs = inputs; };
    treesitter-playground       = prev.callPackage ../packages/treesitter-playground.nix       { inputs = inputs; };
    vim-solarized8              = prev.callPackage ../packages/vim-solarized8.nix              { inputs = inputs; };
  };
in {
  mutt-trim      = prev.callPackage ../packages/mutt-trim.nix      { inputs = inputs; };
  httpie-desktop = prev.callPackage ../packages/httpie-desktop.nix { inputs = inputs; };
  vimPlugins     = prev.vimPlugins  // myVimPlugins;
  myVimPlugins   = myVimPlugins;
}
