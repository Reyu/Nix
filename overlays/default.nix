{ inputs }:
# Pass flake inputs to overlay so we can use the sources pinned in flake.lock
# instead of having to keep hashes in each package for src
final: prev: {
  httpie-desktop = prev.callPackage ../packages/httpie-desktop.nix { inherit inputs; };
}
