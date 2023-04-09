{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
final: prev:
let
  myVimPlugins = {
    bufresize-nvim = prev.callPackage ../packages/bufresize-nvim.nix { inherit inputs; };
    cmp-conventionalcommits = prev.callPackage ../packages/cmp-conventionalcommits.nix { inherit inputs; };
    cmp-dap = prev.callPackage ../packages/cmp-dap.nix { inherit inputs; };
    cmp-nvim-lsp-signature-help = prev.callPackage ../packages/cmp-nvim-lsp-signature-help.nix { inherit inputs; };
    firenvim = prev.callPackage ../packages/firenvim.nix { inherit inputs; };
    haskell-tools-nvim = prev.callPackage ../packages/haskell-tools-nvim.nix { inherit inputs; };
    hydra = prev.callPackage ../packages/hydra.nix { inherit inputs; };
    mind-nvim = prev.callPackage ../packages/mind-nvim.nix { inherit inputs; };
    mini-nvim = prev.callPackage ../packages/mini-nvim.nix { inherit inputs; };
    neogen = prev.callPackage ../packages/neogen.nix { inherit inputs; };
    neosolarized-nvim = prev.callPackage ../packages/NeoSolarized-nvim.nix { inherit inputs; };
    neotest = prev.callPackage ../packages/neotest.nix { inherit inputs; };
    neotest-haskell = prev.callPackage ../packages/neotest-haskell.nix { inherit inputs; };
    neotest-python = prev.callPackage ../packages/neotest-python.nix { inherit inputs; };
    neotest-vim-test = prev.callPackage ../packages/neotest-vim-test.nix { inherit inputs; };
    netman = prev.callPackage ../packages/netman.nix { inherit inputs; };
    nvim-ufo = prev.callPackage ../packages/nvim-ufo.nix { inherit inputs; };
    one-small-step-for-vimkind = prev.callPackage ../packages/one-small-step-for-vimkind.nix { inherit inputs; };
    persistence-nvim = prev.callPackage ../packages/persistence-nvim.nix { inherit inputs; };
    promise-async = prev.callPackage ../packages/promise-async.nix { inherit inputs; };
    smart-splits-nvim = prev.callPackage ../packages/smart-splits.nix { inherit inputs; };
    stickybuf-nvim = prev.callPackage ../packages/stickybuf-nvim.nix { inherit inputs; };
    telescope-hoogle = prev.callPackage ../packages/telescope-hoogle.nix { inherit inputs; };
    treesitter-playground = prev.callPackage ../packages/treesitter-playground.nix { inherit inputs; };
    vim-solarized8 = prev.callPackage ../packages/vim-solarized8.nix { inherit inputs; };
  };
in
{
  mutt-trim = prev.callPackage ../packages/mutt-trim.nix { inherit inputs; };
  httpie-desktop = prev.callPackage ../packages/httpie-desktop.nix { inherit inputs; };
  vimPlugins = prev.vimPlugins // myVimPlugins;
}
