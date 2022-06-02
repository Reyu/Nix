{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "firenvim";
  version = "latest";
  src = inputs.firenvim;

  meta = with lib; {
    description = "Embed Neovim in Chrome, Firefox, Thunderbird & others.";
    homepage = "https://github.com/glacambre/firenvim";
    license = licenses.gpl3;
  };
}

