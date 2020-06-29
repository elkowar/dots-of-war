{ pkgs ? import <nixpkgs> {} }:
{
  bashtop = pkgs.callPackage ./packages/bashtop.nix {};
}
