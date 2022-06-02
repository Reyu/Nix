{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "cmp-nvim-lsp-signature-help";
  version = "latest";
  src = inputs.cmp-nvim-lsp-signature-help;

  meta = with lib; {
    description = "nvim-cmp source for displaying function signatures with the current parameter emphasized";
    homepage = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help";
  };
}

