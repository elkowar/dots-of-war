{
  enable = true;
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
    shell = "/bin/fish";
    mouse = {
      double_click.threshold = 300;
      triple_click.threshold = 300;
      hide_when_typing = true;
      url.launcher.program = "xdg-open";
    };

    background_opacity = 1;
    fonts = {
      size = 12;
      normal.family = "Terminus (TTF)";
      offset.x = 0;
      offset.y = 0;
    };

    colors = {
      primary = {
        background = "#282828";
        foreground = "#ebdbb2";
      };
      normal = {
        black = "#282828";
        red = "#cc241d";
        green = "#98971a";
        yellow = "#d79921";
        blue = "#458588";
        magenta = "#b16286";
        cyan = "#689d6a";
        white = "#a89984";
      };
      bright = {
        black = "#928374";
        red = "#fb4934";
        green = "#b8bb26";
        yellow = "#fabd2f";
        blue = "#83a598";
        magenta = "#d3869b";
        cyan = "#8ec07c";
        white = "#ebdbb2";
      };
    };
  };
}
