{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.desktop;
in
{
  options.elkowar.desktop = {
    enable = lib.mkEnableOption "Desktop configuration enabled";
  };

  imports = [ ./desktop ];



  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (scr.override { extraPackages = [ rofi ]; })
      mmutils
      liquidctl
      bashtop
      cool-retro-term
      gromit-mpx
      polybarFull
      #discord
      pinta
      espanso
      barrier
      #hyper-haskell
      font-manager

      haskellPackages.arbtt
      sqlite-web

      #flameshot


      sxhkd

    ];


    elkowar.desktop = {
      gtk.enable = false;
    };

    elkowar.programs = {
      alacritty.enable = true;
      rofi.enable = true;
      firefox.enable = false;
    };

    programs = {
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

      feh = {
        enable = true;
        keybindings = { zoom_in = "plus"; zoom_out = "minus"; };
      };

    };

    #systemd.user.services.dunst.Environment.DISPLAY = ":1";

    services = {
      mpd = {
        enable = true;
        musicDirectory = "/home/leon/Downloads/music";
      };
      udiskie.enable = true;
      kdeconnect = {
        enable = true;
      };

      #dunst =
        #let dunst_settings = {
          #geometry = "500x5-30+50";
          #background = cfg.colors.primary.bg_darker;
          #foreground = cfg.colors.primary.foreground;
          #padding = "20px";
          #horizontal_padding = "20px";
          #font = "Terminus (TTF)";
        #};
        #in
        #{
          #enable = true;
          #settings.global = dunst_settings;
          #settings.urgency_normal = dunst_settings;

          #settings.urgency_low = dunst_settings;
        #};
    };

    xresources.properties = with config.elkowar.desktop.colors; {
      "Xcursor.size" = "16";
      #"Xcursor.theme" = "capitaine-cursors-light";
      "Xft.autohint" = "0";
      "Xft.antialias" = "1";
      "Xft.hinting" = "true";
      "Xft.hintstyle" = "hintslight";
      "Xft.dpi" = "96";
      "Xft.rgba" = "rgb";
      "Xft.lcdfilter" = "lcddefault";

      "st.font" = "Terminus (TTF):pixelsize=16";
      "st.boxdraw" = 1;
      "st.boxdraw_bold" = 1;
      "st.boxdraw_braille" = 1;
      "st.scrollrate" = 1;

      "*.background" = primary.background;
      "*.foreground" = primary.foreground;
      "*.color0" = normal.black;
      "*.color1" = normal.red;
      "*.color2" = normal.green;
      "*.color3" = normal.yellow;
      "*.color4" = normal.blue;
      "*.color5" = normal.magenta;
      "*.color6" = normal.cyan;
      "*.color7" = normal.white;
      "*.color8" = bright.black;
      "*.color9" = bright.red;
      "*.color10" = bright.green;
      "*.color11" = bright.yellow;
      "*.color12" = bright.blue;
      "*.color13" = bright.magenta;
      "*.color14" = bright.cyan;
      "*.color15" = bright.white;


#"st.termname" = "st-256color";
#"st.borderless" = 1;
#"st.font" = "Terminus (TTF):size=16:antialias=true:autohint=true";
#"st.borderpx" = 10;
#"st.cursorshape" = 3;
#"st.cursorthickness" = 1;
#"st.cursorblinkstyle" = 0;
#"st.cursorblinkontype" = 0;
#"st.disablebold" = 0;
#"st.disableitalics" = 0;
#"st.disableroman" = 0;
#"st.scrollrate" = 1;
#"st.blinktimeout" = 100;
#"st.bellvolume" = 5;
#"st.actionfps" = 60;
#"st.mouseScrollLines" = 3;
#"st.boxdraw" = 1;
#"st.boxdraw_bold" = 1;
#"st.boxdraw_braille" = 1;
#"st.opacity" = 255;
#"st.disable_alpha_correction" = 0;
#"st.prompt_char" = "λ  !`printf '\033[z'`";
#"st.shell" = "/usr/bin/bash";
    };
  };
}
