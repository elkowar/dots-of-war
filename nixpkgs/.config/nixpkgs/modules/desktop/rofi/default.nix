{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.programs.rofi;
in
{
  options.elkowar.programs.rofi = {
    enable = lib.mkEnableOption "Enable rofi";
  };

  config = {
    programs.rofi = lib.mkIf cfg.enable {
      enable = true;
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = with config.elkowar.desktop.colors; builtins.toString (pkgs.writeText "rofi-theme" ''
        configuration {
          drun-display-format: "{icon} {name}";
          display-drun: "Applications";
        	show-icons: true;
        	icon-theme: "Papirus";
        	location: 0;
        	yoffset: 0;
          xoffset: 0;
        	columns: 2;
        	fake-transparency: false;
        	hide-scrollbar: true;
        	bw: 0;
          fullscreen: false;
          show-icons: true;
        	terminal: "termite";
        	sidebar-mode: false;
        }

        * {
          accent:           ${normal.cyan};
          background:       ${primary.bg_darker};
          background-light: ${primary.background};
          foreground:       ${primary.foreground};
          on:               ${normal.green};
          off:              ${normal.blue};
        }

        * {
          text-font:                            "Iosevka 12";

          inputbar-margin:                      3px 3px;
          prompt-padding:                       10px 10px;
          entry-padding:                        10px 0px 10px 0px;
          list-element-padding:                 10px;
          list-element-margin:                  @inputbar-margin;
          list-element-border:                  0px 0px 0px 4px;

          apps-textbox-prompt-colon-padding:    10px -5px 0px 0px;
        }

        #window {
          width: 50%;
          height: 60%;
          padding: 40px 40px;
        }

        * {
          background-color: @background;
          text-color: @foreground;
          font: @text-font;
        }

        inputbar,
        prompt,
        textbox-prompt-colon,
        entry,
        element-text, element-icon {
          background-color: @background-light;
        }

        #inputbar {
          children: [ prompt, textbox-prompt-colon, entry ];
          margin: @inputbar-margin;
        }

        #prompt {
          padding: @prompt-padding;
          background-color: @accent;
          text-color: @background;
        }

        #textbox-prompt-colon {
          expand: false;
          str: "  ::  ";
          padding: @apps-textbox-prompt-colon-padding;
        }

        #entry {
          text-color: @accent;
          padding: @entry-padding;
        }

        #element {
          padding: @list-element-padding;
          margin: @list-element-margin;
          border: @list-element-border;
          background-color: @background-light;
          border-color: @background-light;
        }

        #element.selected {
          background-color: @background-focus;
          text-color: @accent;
          border-color: @accent;
        }
      ''
      );
    };
  };
}
