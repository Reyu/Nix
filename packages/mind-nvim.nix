{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "mind-nvim";
  version = "latest";
  src = inputs.mind-nvim;

  meta = with lib; {
    description = "The power of trees at your fingertips";
    homepage = "https://github.com/phaazon/mind.nvim";
  };
}

