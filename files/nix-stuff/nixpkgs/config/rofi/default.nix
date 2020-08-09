{ myConf, pkgs ? import <nixpkgs> }:
{
  enable = true;
  package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
  theme = "/home/leon/nixpkgs/config/rofi/default_theme.rasi";
  #theme = ./default_theme.rasi;
  terminal = "${pkgs.alacritty}/bin/alacritty";
}
