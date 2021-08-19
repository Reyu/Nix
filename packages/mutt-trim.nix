{ pkgs ? import <nixpkgs> {} }:

with pkgs.lib;

pkgs.stdenv.mkDerivation rec {
  name = "mutt-trim";

  meta = {
    description = "Removes clutter of quoted text when responding to emails";
    homepage = "https://github.com/Konfekt/mutt-trim";
  };

  buildInputs = [ pkgs.perl ];

  src = pkgs.fetchFromGitHub {
    owner = "Konfekt";
    repo = "mutt-trim";
    rev = "08ef5faf07b06b9abda7909f5b15cf84150f821a";
    sha256 = "Rd51+XPa3L7t+6dlWaHcaY7hBKKWeg5hQhBekFsQcOw=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp mutt-trim $out/bin
    chmod +x $out/bin/mutt-trim
  '';
}
