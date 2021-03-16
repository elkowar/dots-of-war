{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [ pkgs.pscircle pkgs.asciiquarium pkgs.cmatrix ];
}
