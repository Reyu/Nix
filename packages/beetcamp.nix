{ lib
, buildPythonPackage
, fetchPypi
, cached-property
, pycountry
, requests
}:

buildPythonPackage rec {
  pname = "beetcamp";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef8b1b0eada60a48a0fe2d0833202dd69fb8b2da34a74e44c001cb9b3682a29f";
  };

  propagatedBuildInputs = [
    cached-property
    pycountry
    requests
  ];

  meta = with lib; {
    description = "Bandcamp autotagger source for beets (http://beets.io";
    homepage = https://github.com/snejus/beetcamp;
  };
}
