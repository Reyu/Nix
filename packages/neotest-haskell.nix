{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neotest-haskell";
  version = "latest";
  src = inputs.neotest-haskell;

  meta = {
    description = "Neotest adapter for Haskell (cabal-v2 or stack) with Hspec";
    homepage = "https://github.com/MrcJkb/neotest-haskell";
    license = lib.licenses.gpl2;
  };
}

