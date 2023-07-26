{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
_: prev:
let
  vimPlugins = {
    bufresize-nvim = prev.callPackage ../packages/bufresize-nvim.nix { inherit inputs; };
    edgy-nvim = prev.callPackage ../packages/edgy-nvim.nix { inherit inputs; };
    github-nvim-theme = prev.callPackage ../packages/github-nvim-theme.nix { inherit inputs; };
  };
in
{
  httpie-desktop = prev.callPackage ../packages/httpie-desktop.nix { inherit inputs; };
  vimPlugins = prev.vimPlugins // vimPlugins;
}
