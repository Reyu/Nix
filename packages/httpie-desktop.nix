{ pkgs, ... }:
let
  inherit (pkgs) appimageTools fetchurl;
  version = "2022.11.1";
  pname = "httpie-desktop";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/httpie/desktop/releases/download/v${version}/HTTPie-${version}.AppImage";
    sha256 = "0p51ln102csnq801icbc09jlyvdcl9vqp7nzz42y4b4i8z1a3vb9";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/httpie.desktop $out/share/applications/httpie.desktop
    install -m 444 -D ${appimageContents}/httpie.png $out/share/icons/hicolor/512x512/apps/httpie.png
    substituteInPlace $out/share/applications/httpie.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "HTTPie.io appImage";
    longDescription = ''
      The latest build of https://httpie.io, in appImage form, suitably nixed
    '';
    homepage = "https://httpie.io";
    platforms = [ "x86_64-linux" ];
  };
}
