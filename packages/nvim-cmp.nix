{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-cmp";
  version = "latest";
  src = inputs.nvim-cmp;

  meta = with lib; {
    description = "A completion plugin for neovim coded in Lua";
    homepage = "https://github.com/hrsh7th/nvim-cmp";
    license = licenses.mit;
  };
}

