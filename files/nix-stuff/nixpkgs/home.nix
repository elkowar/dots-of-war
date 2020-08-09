# https://nixos.wiki/wiki/Wrappers_vs._Dotfiles
# https://nixos.org/nixos/manual/index.html#sec-writing-modules

# do this to change to fork
# nix-channel --add https://github.com/ElKowar/home-manager/archive/alacritty-package-option.tar.gz home-manager
# nix-channel --update
# nix-env -u home-manager

{ config, pkgs, ... }:
let
  elkowar_local = import ./local/default.nix {};
  myConf = import ./myConfig.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    cool-retro-term = (
      pkgs.writeScriptBin "cool-retro-term" ''
        #!/bin/sh
        exec nixGLIntel ${pkgs.cool-retro-term}/bin/cool-retro-term "$@"
      ''
    );
  };

  profiles = {
    base.enable = true;
    desktop.enable = true;
  };



  imports = [ ./profiles/base.nix ./profiles/desktop.nix ];
}
