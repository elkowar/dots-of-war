{ pkgs ? import <nixpkgs> {} }:
{
  bashtop = pkgs.callPackage ./packages/bashtop.nix {};
  liquidctl = pkgs.callPackage ./packages/liquidctl.nix {};
}
