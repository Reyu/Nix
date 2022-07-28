{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "netman";
  version = "latest";
  src = inputs.netman;

  meta = with lib; {
    description = "Neovim (Lua powered) Network Resource Manager";
    homepage = "https://github.com/miversen33/netman.nvim";
  };
}

