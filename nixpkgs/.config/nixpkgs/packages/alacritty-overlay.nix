{ nixGL, symlinkJoin, makeWrapper, writeScriptBin, alacritty, fetchFromGitHub, lib }:
let
  wrapped =
    writeScriptBin "alacritty" ''
        #!/bin/sh
        exec ${nixGL.nixGLIntel}/bin/nixGLIntel ${alacritty}/bin/alacritty "$@"
    '';
in
symlinkJoin {
  name = "alacritty";
  nativeBuildInputs = [ makeWrapper ];
  paths = [
    wrapped
    alacritty
    #(alacritty.overrideAttrs (oldAttrs: rec {
      #src = fetchFromGitHub {
        #owner = "zenixls2";
        #repo = "alacritty";
        #rev = "ligature";
        #sha256 = "00jyhq7wrb2jpzmif4mimbh6p3wwa7rd1chsdwcdi0j9i9w2jpkx";
      #};
      #cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        #name = "alacritty-vendor.tar.gz";
        #inherit src;
        #outputHash = "1sg1ay31x8n60j76vg7lg4a24vilv5wd9pgpwphzgf6arbyx7wpn";
      #});
    #}))
  ];
}
