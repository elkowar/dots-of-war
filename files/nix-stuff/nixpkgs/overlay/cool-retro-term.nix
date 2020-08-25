{ nixGL, symlinkJoin, makeWrapper, writeScriptBin, cool-retro-term }:
symlinkJoin {
  name = "cool-retro-term";
  nativeBuildInputs = [ makeWrapper ];

  paths = [
    (
      writeScriptBin "cool-retro-term" ''
        writeScriptBin "cool-retro-term"
          #!/bin/sh
          exec ${nixGL.nixGLIntel}/bin/nixGLIntel ${cool-retro-term}/bin/cool-retro-term "$@"
      ''
    )
    cool-retro-term
  ];
}
