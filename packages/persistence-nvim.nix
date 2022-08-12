{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "persistence-nvim";
  version = "latest";
  src = inputs.persistence-nvim;

  meta = with lib; {
    description = "Simple session management for Neovim";
    homepage = "https://github.com/folke/persistence.nvim";
  };
}

