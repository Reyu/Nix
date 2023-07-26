{ pkgs, ... }: {
  imports = [
    ./common.nix
    ../modules/git
  ];
  home.packages = with pkgs; [ htop ripgrep rsync ];
}
