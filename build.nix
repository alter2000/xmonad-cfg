{ mkDerivation, stdenv
, base, containers, hpack, unix, xmonad, xmonad-contrib
}:

let
  baseDepends = [
    base
    containers
    unix
    xmonad
    xmonad-contrib
  ];
in
mkDerivation {
  pname = "xmonad";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;

  libraryToolDepends = [ hpack ];
  libraryHaskellDepends = baseDepends ++ [ ];

  executableHaskellDepends = baseDepends ++ [ ];

  testHaskellDepends = baseDepends ++ [ ];

  prePatch = "hpack";
  homepage = "https://github.com/alter2000/xmonad-cfg#readme";
  license = stdenv.lib.licenses.bsd3;
}
