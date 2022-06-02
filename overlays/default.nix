{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
final: prev: rec {
  mutt-trim = prev.callPackage ../packages/mutt-trim.nix { inputs = inputs; };
  vimPlugins = prev.vimPlugins // {
    cmp-conventionalcommits =
      prev.callPackage ../packages/cmp-conventionalcommits.nix {
        inputs = inputs;
      };
    cmp-dap = prev.callPackage ../packages/cmp-dap.nix { inputs = inputs; };
    cmp-nvim-lsp-signature-help =
      prev.callPackage ../packages/cmp-nvim-lsp-signature-help.nix {
        inputs = inputs;
      };
    firenvim = prev.callPackage ../packages/firenvim.nix { inputs = inputs; };
    one-small-step-for-vimkind =
      prev.callPackage ../packages/one-small-step-for-vimkind.nix {
        inputs = inputs;
      };
    telescope-hoogle =
      prev.callPackage ../packages/telescope-hoogle.nix { inputs = inputs; };
    vim-solarized8 =
      prev.callPackage ../packages/vim-solarized8.nix { inputs = inputs; };
  };
}
