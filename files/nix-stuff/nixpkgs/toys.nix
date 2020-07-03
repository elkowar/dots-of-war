{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [ pkgs.ytop pkgs.pscircle pkgs.asciiquarium pkgs.cmatrix ];
}
