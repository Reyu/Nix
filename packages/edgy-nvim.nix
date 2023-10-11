{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "edgy.nvim";
  version = "latest";
  src = inputs.edgy-nvim;

  meta = with lib; {
    description = "Easily create and manage predefined window layouts, bringing a new edge to your workflow";
    homepage = "https://github.com/folke/edgy.nvim";
  };
}

