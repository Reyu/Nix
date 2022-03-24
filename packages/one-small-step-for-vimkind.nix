{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "one-small-step-for-vimkind";
  version = "latest";
  src = inputs.one-small-step-for-vimkind;

  meta = with lib; {
    description = "Debug adapter for Neovim plugins";
    homepage = "https://github.com/jbyuki/one-small-step-for-vimkind";
    license = licenses.mit;
  };
}

