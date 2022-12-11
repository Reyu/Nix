{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "smart-splits.nvim";
  version = "latest";
  src = inputs.smart-splits;

  meta = with lib; {
    description = "Smart, directional, Neovim and tmux split resizing and navigation.";
    homepage = "https://github.com/mrjones2014/smart-splits.nvim";
    license = licenses.mit;
  };
}

