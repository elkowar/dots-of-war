{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.desktop;
  elkowar_local = import ../local/default.nix {};
  myConf = import ../myConfig.nix;
in
{
  options.profiles.desktop = {
    enable = lib.mkEnableOption "Desktop configuration enabled";
  };

  config = lib.mkIf cfg.enable {

    gtk = import ../config/gtk.nix { inherit pkgs; inherit myConf; };

    home.packages = with pkgs; [
      elkowar_local.bashtop
      elkowar_local.liquidctl

      cool-retro-term
      simplescreenrecorder
      gromit-mpx
      #hyper-haskell
    ];

    programs = {
      alacritty = import ../config/alacritty.nix { inherit pkgs; inherit myConf; }; # <- https://github.com/guibou/nixGL
      feh = import ../config/feh.nix;
      rofi = import ../config/rofi { inherit pkgs; inherit myConf; };

      mpv = {
        enable = true;
        bindings = {
          WHEEL_UP = "add volume 5";
          WHEEL_DOWN = "add volume -5";
          WHEEL_LEFT = "seek -3";
          WHEEL_RIGHT = "seek 3";
          h = "seek -3";
          l = "seek 3";
        };
      };

    };

    services = {
      mpd = {
        enable = true;
        musicDirectory = "/home/leon/Downloads/music";
      };
      udiskie.enable = true;
    };
  };
}
