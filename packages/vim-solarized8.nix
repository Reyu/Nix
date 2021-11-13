{ pkgs, stdenv, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "vim-solarized8";
  version = "latest";
  src = inputs.vim-solarized8;

  meta = {
    description = "Optimized Solarized colorschemes. Best served with true-color terminals!";
    homepage = "https://github.com/lifepillar/vim-solarized8";
  };
}

