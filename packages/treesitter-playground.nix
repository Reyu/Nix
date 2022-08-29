{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "treesitter-playground";
  version = "latest";
  src = inputs.treesitter-playground;

  meta = with lib; {
    description = "Treesitter playground integrated into Neovim ";
    homepage = "https://github.com/nvim-treesitter/playground";
    license = licenses.apsl20;
  };
}

