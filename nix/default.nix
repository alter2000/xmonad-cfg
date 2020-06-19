{ pkgs ? import <nixpkgs> {}
, compiler ? "ghc883"
}:

with pkgs.haskell;

lib.dontCheck (packages.${compiler}.callPackage ./build.nix { })
