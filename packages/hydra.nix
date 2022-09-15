{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "hydra";
  version = "latest";
  src = inputs.hydra;

  meta = with lib; {
    description = "Create custom submodes and menus";
    homepage = "https://github.com/anuvyklack/hydra.nvim";
  };
}

