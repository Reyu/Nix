{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nivm-ufo";
  version = "latest";
  src = inputs.nvim-ufo;

  meta = with lib; {
    description = "Not UFO in the sky, but an ultra fold in Neovim. ";
    homepage = "https://github.com/kevinhwang91/nvim-ufo";
    license = licenses.bsd3;
  };
}

