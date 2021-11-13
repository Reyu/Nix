{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "cmp-nvim-lsp";
  version = "latest";
  src = inputs.cmp-nvim-lsp;

  meta = with lib; {
    description = "nvim-cmp source for neovim builtin LSP client";
    homepage = "https://github.com/hrsh7th/cmp-nvim-lsp";
    license = licenses.mit;
  };
}

