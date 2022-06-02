{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "cmp-conventionalcommits";
  version = "latest";
  src = inputs.cmp-conventionalcommits;

  meta = with lib; {
    description = "nvim-cmp source for conventional commit scopes";
    homepage = "https://github.com/davidsierradz/cmp-conventionalcommits";
    license = licenses.mit;
  };
}

