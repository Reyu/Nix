{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "telescope-hoogle";
  version = "latest";
  src = inputs.telescope-hoogle;

  meta = with lib; {
    description = "Hoogle search integration for Telescope";
    homepage = "https://github.com/luc-tielen/telescope-hoogle";
    license = licenses.mit;
  };
}

