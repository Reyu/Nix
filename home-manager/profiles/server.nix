{ config, pkgs, lib, nur, ... }: {
  imports = [
    ./common.nix
    ../modules/git
  ];
  home.packages = with pkgs; [ htop ripgrep rsync ];
}
