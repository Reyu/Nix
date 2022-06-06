{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "nvim-treesitter-endwise";
  version = "latest";
  src = inputs.nvim-treesitter-endwise;

  meta = with lib; {
    description = "Wisely add 'end' in Ruby, Vimscript, Lua, etc. Tree-sitter aware alternative to tpope's vim-endwise ";
    homepage = "https://github.com/RRethy/nvim-treesitter-endwise";
    license = licenses.mit;
  };
}

