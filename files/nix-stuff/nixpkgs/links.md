writers: 
https://nixos.wiki/wiki/Nix-writers

variable replacement: 
builtins.readFile (pkgs.substituteAll { src = ./nixhello.txt; name = "Major Tom"; })
that will replace all @name@ in the file with Major Tom
https://nixos.org/nixpkgs/manual/#fun-substituteAll


