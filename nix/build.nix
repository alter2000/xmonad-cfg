{ mkDerivation, stdenv
, base, async, containers, unix, xmonad, xmonad-contrib, xmonad-extras
}:

let
  baseDepends = [
    base
    async
    containers
    unix
    xmonad
    xmonad-contrib
    xmonad-extras
  ]
  ;
in
mkDerivation {
  pname = "xmonad-cfg";
  version = "0.1.0.0";
  src = builtins.path { path = ./..; name = "xmonad-cfg"; };
  isLibrary = true;
  isExecutable = true;

  executableHaskellDepends = baseDepends ++ [
  ];

  testHaskellDepends = baseDepends ++ [
  ];

  # prePatch = "hpack";
  homepage = "https://github.com/alter2000/xmonad-cfg#readme";
  license = stdenv.lib.licenses.bsd3;
}
