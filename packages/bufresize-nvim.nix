{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "bufresize.nvim";
  version = "latest";
  src = inputs.bufresize-nvim;

  meta = with lib; {
    description = "Keep buffer dimensions in proportion when terminal window is resized";
    homepage = "https://github.com/kwkarlwang/bufresize.nvim";
    license = licenses.mit;
  };
}

