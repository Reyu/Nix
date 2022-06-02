{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "cmp-dap";
  version = "latest";
  src = inputs.cmp-dap;

  meta = with lib; {
    description = "nvim-cmp source for nvim-dap REPL and nvim-dap-ui buffers";
    homepage = "https://github.com/rcarriga/cmp-dap";
    license = licenses.mit;
  };
}

