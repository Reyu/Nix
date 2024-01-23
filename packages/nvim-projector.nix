{ pkgs, stdenv, lib, inputs, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "nvim-projector";
  version = "latest";
  src = inputs.nvim-projector;

  meta = with lib; {
    description = "Better project-specific configs for nvim-dap with telescope! ";
    homepage = "https://github.com/kndndrj/nvim-projector";
    license = licenses.gpl3;
  };
}

