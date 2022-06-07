{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neotest-vim-test";
  version = "latest";
  src = inputs.neotest-vim-test;

  meta = with lib; {
    description = "Neotest adapter for vim-test";
    homepage = "https://github.com/rcarriga/neotest-vim-test";
  };
}

