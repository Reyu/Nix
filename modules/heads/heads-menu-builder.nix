{ pkgs }:

pkgs.substituteAll {
  src = ./heads-menu-builder.sh;
  isExecutable = true;
  path = [
    pkgs.coreutils
    pkgs.gnused
    pkgs.gnugrep
  ];
  inherit (pkgs) bash;
}
