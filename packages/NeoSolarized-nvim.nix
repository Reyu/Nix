{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "NeoSolarized.nvim";
  version = "latest";
  src = inputs.neosolarized-nvim;

  meta = with lib; {
    description = "NeoSolarized colorscheme for NeoVim with full transparency ";
    homepage = "https://github.com/Tsuzat/NeoSolarized.nvim";
    license = licenses.mit;
  };
}

