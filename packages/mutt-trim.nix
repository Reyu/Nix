{ stdenv, perl, inputs }:

stdenv.mkDerivation rec {
  name = "mutt-trim";

  meta = {
    description = "Removes clutter of quoted text when responding to emails";
    homepage = "https://github.com/Konfekt/mutt-trim";
  };

  buildInputs = [ perl ];

  src = inputs.mutt-trim;
  installPhase = ''
    mkdir -p $out/bin
    cp mutt-trim $out/bin
    chmod +x $out/bin/mutt-trim
  '';
}
