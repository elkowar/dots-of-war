{ pkgs }:

pkgs.writeScriptBin "cool-retro-term" ''
  #!/bin/sh
  exec nixGLIntel ${pkgs.cool-retro-term}/bin/cool-retro-term "$@"
''
