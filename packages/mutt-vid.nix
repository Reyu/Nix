{ pkgs ? import <nixpkgs> {} }:

with pkgs.lib;

pkgs.stdenv.mkDerivation rec {
  name = "mutt-vid";

  meta = {
    description = "Manage multiple sender accounts in mutt";
    homepage = "https://gitlab.com/protist/mutt-vid";
    license = licenses.gpl3;
  };

  src = pkgs.fetchFromGitLab {
    owner = "protist";
    repo = "mutt-vid";
    rev = "ebdeab5292af6f3bbf942d583a80a61575850840";
    sha256 = "133af2m8c99kfq1gy8k2nj74bxsag78lm80q1zid33vm9vsn5anh";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp mutt-vid $out/bin
    chmod +x $out/bin/mutt-vid
  '';
}
