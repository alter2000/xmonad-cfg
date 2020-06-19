{ pkgs ? import <nixpkgs> {}
, compiler ? "ghc881"
}:

pkgs.mkShell {
  buildInputs =
    with pkgs.haskell.packages.${compiler};
    [ stack
      # ghcide
    ];
}
