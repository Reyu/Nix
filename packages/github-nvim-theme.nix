{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "vimplugin-github-nvim-theme";
  version = "latest";
  src = inputs.github-nvim-theme;

  meta = with lib; {
    description = "Github's Neovim themes";
    homepage = "https://github.com/projekt0n/github-nvim-theme";
    license = licenses.mit;
  };
}

