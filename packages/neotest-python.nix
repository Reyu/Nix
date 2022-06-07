{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neotest-python";
  version = "latest";
  src = inputs.neotest-python;

  meta = with lib; {
    description = "Neotest plugin for Python";
    homepage = "https://github.com/rcarriga/neotest-python";
  };
}

