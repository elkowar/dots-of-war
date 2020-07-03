{ pkgs, myConf, ... }:
{
  enable = true;
  package = (
    pkgs.writeScriptBin "alacritty" ''
      #!/bin/sh
      exec nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
    ''
  );
  settings = {
    window = {
      padding.x = 20;
      padding.y = 20;
      dynamic_padding = true;
    };
    dynamic_title = true;
    cursor = {
      style = "Block";
      unfocused_hollow = true;
    };
    shell = "/home/leon/.nix-profile/bin/zsh";
    mouse = {
      double_click.threshold = 300;
      triple_click.threshold = 300;
      hide_when_typing = true;
      url.launcher.program = "xdg-open";
    };

    background_opacity = 1;
    font = {
      size = 12;
      #normal.family = "Iosevka";
      normal.family = "Terminus (TTF)";
      offset.x = 0;
      offset.y = 0;
    };
    colors = myConf.colors;
  };
}
