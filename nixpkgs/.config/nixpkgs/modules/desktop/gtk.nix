{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.desktop.gtk;
in
{
  options.elkowar.desktop.gtk = {
    enable = lib.mkEnableOption "Enable gtk configuration";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      #theme.name = "elkowars_phocus";
      theme.name = "gruvbox-phocus";
      iconTheme.name = "oomox-materia-dark";
      #iconTheme.name = "Numix";
      #font.name = "Terminus (TTF) 12";
      font.name = "xos4 Terminus 12";

      gtk2.extraConfig = ''gtk-theme-name = "Adwaita-dark"'';

      gtk3.extraConfig = {
        gtk-menu-images = 1;
        gtk-xft-hinting = 1;
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = 1;
        gtk-decoration-layout = ":";
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        #gtk-enable-even-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-button-images = 1;
        #ctk-cursor-theme-name = "capitaine-cursors-light";
        gtk-cursor-theme-size = 0;
        gtk-cursor-theme-name="phinger-cursors-light";
      };

      gtk3.extraCss = ''
        .termite {
          padding: 15px;
        }
        vte-terminal {
          padding: 10px;
        }
        /*#Emacs > box {
          padding: 20px;
        }*/
      '';
    };
  };
}
