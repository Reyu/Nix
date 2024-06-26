{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
_: prev: {
  hc-utils = prev.callPackage ../packages/hc-utils.nix { };
  simplex-chat = prev.callPackage ../packages/simplex-chat.nix { };
  httpie-desktop = prev.callPackage ../packages/httpie-desktop.nix { inherit inputs; };
  vimPlugins = prev.vimPlugins.extend (
    _: _: {
      bufresize-nvim = prev.callPackage ../packages/bufresize-nvim.nix { inherit inputs; };
      edgy-nvim = prev.callPackage ../packages/edgy-nvim.nix { inherit inputs; };
      github-nvim-theme = prev.callPackage ../packages/github-nvim-theme.nix { inherit inputs; };
      nvim-projector = prev.callPackage ../packages/nvim-projector.nix { inherit inputs; };
    }
  );
}
