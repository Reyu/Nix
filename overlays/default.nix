{ inputs }:
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep hashes in each package for src
final: prev: rec {
  mutt-trim = prev.callPackage ../packages/mutt-trim.nix { inputs = inputs; };
  vimPlugins = prev.vimPlugins // {
    cmp-buffer = prev.callPackage ../packages/cmp-buffer.nix { inputs = inputs; };
    cmp-nvim-lsp =
      prev.callPackage ../packages/cmp-nvim-lsp.nix { inputs = inputs; };
    nvim-cmp = prev.callPackage ../packages/nvim-cmp.nix { inputs = inputs; };
    telescope-hoogle =
      prev.callPackage ../packages/telescope-hoogle.nix { inputs = inputs; };
    vim-solarized8 =
      prev.callPackage ../packages/vim-solarized8.nix { inputs = inputs; };
  };
}
