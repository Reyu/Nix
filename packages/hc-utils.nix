{
stdenv,
fetchurl,
lib,
dpkg,
bash,
coreutils,
... }:
let
  version = "0.0.4";
  pname = "hc-utils";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://packages.hetzner.com/hcloud/deb/${pname}_${version}-1_all.deb";
    sha256 = "151e780568cc23970e5f26f24b82dea383a5116197fd91cae9254ec2b23918a7";
  };
in
stdenv.mkDerivation {
  inherit name src;
  system = "x86_64-linux";

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    dpkg
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv {lib,usr/*} $out

    substituteInPlace $out/lib/udev/rules.d/99-hc-volume-automount.rules \
        --replace /bin/sh "${bash}/bin/bash" \
        --replace /bin/mkdir "${coreutils}/bin/mkdir" \
        --replace /bin/systemctl "/run/current-system/systemd/bin/systemctl"

    runHook postInstall
  '';

  meta = {
    description = "Hetzner Cloud Networks Configuration";
    homepage = "https://docs.hetzner.com/cloud/networks/server-configuration";
    license = lib.licenses.mit;
    maintainers = [{ email = "reyu@reyuzenfold.com"; github = "Reyu"; githubId = 1259365; name = "Timothy Millican"; }];
    platforms = lib.platforms.linux;
  };
}
