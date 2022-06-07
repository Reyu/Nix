{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neotest";
  version = "latest";
  src = inputs.neotest;

  meta = with lib; {
    description = "An extensible framework for interacting with tests within NeoVim.";
    homepage = "https://github.com/rcarriga/neotest";
  };
}

