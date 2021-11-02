final: prev: rec {
  mutt-trim = prev.callPackage ../packages/mutt-trim.nix { };
  vimPlugins = prev.vimPlugins
    // prev.callPackage ../packages/vimPlugins.nix { };
  python39Packages = prev.python39Packages // {
    beetcamp = prev.python39Packages.callPackage ../packages/beetcamp.nix { };
  };
}
