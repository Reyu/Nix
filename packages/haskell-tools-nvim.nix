{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "haskell-tools.nvim";
  version = "latest";
  src = inputs.haskell-tools-nvim;

  meta = {
    description = "Supercharge your Haskell experience in neovim!";
    homepage = "https://github.com/MrcJkb/haskell-tools.nvim";
    license = lib.licenses.gpl2;
  };
}
