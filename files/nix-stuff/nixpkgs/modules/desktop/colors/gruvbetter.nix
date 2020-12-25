rec {
  #accent = bright.cyan;
  #accentDark = normal.cyan;



! black
*.color0:       #0f1010
*.color8:       #73665a

! red
*.color1:       #cc241d
*.color9:       #fb4934

! green
*.color2:       #98971a
*.color10:      #a7aa2e

! yellow
*.color3:       #ce8b3a
*.color11:      #fabd2f

! blue
*.color4:       #458588
*.color12:      #9f83a5

! magenta
*.color5:       #b16286
*.color13:      #d3869b

! cyan
*.color6:       #689d6a
*.color14:      #8ec07c

! white
*.color7:       #a89984
*.color15:      #cdbe96

#*.cursorColor:  #d8c9a3
  primary = {
    foreground=   "#d8c9a3";
    background=   "#0f1010";
    #background=   "#0f1010";
    bg_darker = "#1d2021";
    bg_lighter = "#3c3836";
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

}
