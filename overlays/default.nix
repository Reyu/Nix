final: prev: rec {
  mutt-trim = prev.callPackage ../packages/mutt-trim.nix { };
  vimPlugins = prev.vimPlugins // prev.callPackage ../packages/vimPlugins.nix { };
}
