# https://nixos.wiki/wiki/Wrappers_vs._Dotfiles
# https://nixos.org/nixos/manual/index.html#sec-writing-modules

# do this to change to fork
# nix-channel --add https://github.com/ElKowar/home-manager/archive/alacritty-package-option.tar.gz home-manager
# nix-channel --update
# nix-env -u home-manager

{ config, pkgs, ... }:
{



  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
    overlays = [ (import ./overlay) ];

  };




  elkowar = {
    base = {
      enable = true;
      enableFish = true;
      enableZsh = false;
      includeNiceToHaves = true;
      includeHaskellDev = true;
    };
    desktop.enable = true;
    desktop.colors = import ./modules/desktop/colors/gruvbox.nix;
  };

  imports = [ ./modules ];
}
