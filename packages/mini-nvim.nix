{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "mini.nvim";
  version = "latest";
  src = inputs.mini-nvim;

  meta = with lib; {
    description =
      "Neovim plugin with collection of minimal, independent, and fast Lua modules dedicated to improve Neovim (version 0.5 and higher) experience";
    homepage = "https://github.com/echasnovski/mini.nvim";
    license = licenses.mit;
  };
}
