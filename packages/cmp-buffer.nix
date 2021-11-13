{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "cmp-buffer";
  version = "latest";
  src = inputs.cmp-buffer;

  meta = with lib; {
    description = "nvim-cmp source for buffer words";
    homepage = "https://github.com/hrsh7th/cmp-buffer";
    license = licenses.mit;
  };
}

