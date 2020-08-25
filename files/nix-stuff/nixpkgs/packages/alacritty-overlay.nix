{ nixGL, symlinkJoin, makeWrapper, writeScriptBin, alacritty }:
let
  wrapped =
    writeScriptBin "alacritty" ''
      writeScriptBin "alacritty"
        #!/bin/sh
        exec ${nixGL.nixGLIntel}/bin/nixGLIntel ${alacritty}/bin/alacritty "$@"
    '';
in
symlinkJoin {
  name = "alacritty";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ wrapped alacritty ];
}
