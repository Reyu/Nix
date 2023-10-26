{
autoPatchelfHook,
fetchurl,
gmp,
lib,
openssl,
stdenv,
zlib,
... }:
let
  version = "5.3.2";
  pname = "simplex-chat";

  src = fetchurl {
    url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-chat-ubuntu-22_04-x86-64";
    sha256 = "C3dd1BRyoTSxy4KUVkHyUKq4AxKvUHVtXLBlQHpFFvg=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  system = "x86_64-linux";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gmp
    openssl
    zlib
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D $src $out/bin/simplex-chat
    runHook postInstall
  '';

  meta = {
    description = "The first messaging platform operating without user identifiers of any kind";
    homepage = "https://simplex.chat/";
    platforms = lib.platforms.linux;
  };
}
