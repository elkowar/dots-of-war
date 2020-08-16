{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.programs.alacritty;
in
{
  options.elkowar.programs.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
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
          dynamic_title = true;
        };
        cursor = {
          style = "Block";
          unfocused_hollow = true;
        };
        shell = "/home/leon/.nix-profile/bin/zsh";
        #shell = "/usr/bin/fish";
        mouse = {
          double_click.threshold = 300;
          triple_click.threshold = 300;
          hide_when_typing = true;
          url.launcher.program = "xdg-open";
        };

        key_bindings = [
          {
            key = "N";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
        ];

        background_opacity = 1;
        font = {
          size = 12;
          #normal.family = "Iosevka";
          normal.family = "Terminus (TTF)";
          offset.x = 0;
          offset.y = -2;
        };
        colors = config.elkowar.desktop.colors;
      };
    };
  };
}
