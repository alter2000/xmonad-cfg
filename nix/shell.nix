{ pkgs ? import <nixpkgs> {}
, compiler ? "ghc883"
}:

pkgs.mkShell {
  buildInputs =
    with pkgs.haskell.packages.${compiler};
    [ (import ./default.nix {})
      # ghcide
    ];
}
