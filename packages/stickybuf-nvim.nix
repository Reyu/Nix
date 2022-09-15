{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "stickybuf-nvim";
  version = "latest";
  src = inputs.stickybuf-nvim;

  meta = with lib; {
    description = "Neovim plugin for locking a beffer to a window";
    homepage = "https://github.com/stevearc/stickybuf.nvim";
    license = licenses.mit;
  };
}

