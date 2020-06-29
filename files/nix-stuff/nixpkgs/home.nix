{ config, pkgs, ... }:
let
  elkowar_local = import ./local/default.nix {};
in
{

  home.packages = [
    elkowar_local.bashtop
    pkgs.htop
    pkgs.direnv
    pkgs.rnix-lsp
    pkgs.nix-prefetch-git
  ];

  programs.home-manager.enable = true;

  home.username = "leon";
  home.homeDirectory = "/home/leon";

  home.stateVersion = "20.09";
}
