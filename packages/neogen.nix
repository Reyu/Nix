{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "neogen";
  version = "latest";
  src = inputs.neogen;

  meta = with lib; {
    description = "Abetter annotation generator";
    homepage = "https://github.com/danymat/neogen";
    license = licenses.gpl3;
  };
}

