{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "promise-async";
  version = "latest";
  src = inputs.promise-async;

  meta = with lib; {
    description = "Promise & Async in Lua";
    homepage = "https://github.com/kevinhwang91/promise-async";
    license = licenses.bsd3;
  };
}

