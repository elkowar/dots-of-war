# https://nixos.wiki/wiki/Wrappers_vs._Dotfiles
# https://nixos.org/nixos/manual/index.html#sec-writing-modules

# do this to change to fork
# nix-channel --add https://github.com/ElKowar/home-manager/archive/alacritty-package-option.tar.gz home-manager
# nix-channel --update
# nix-env -u home-manager

{ config, pkgs, ... }:
let
  elkowar_local = import ./local/default.nix {};
  myConf = import ./myConfig.nix;
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


  home.packages = with pkgs; [
    elkowar_local.bashtop
    direnv
    rnix-lsp
    nix-prefetch-git
    gtop
    simplescreenrecorder
    bat
    fontforge
    websocat
    #zsh-completions
    niv
    #pkgs.timg
  ];


  programs = {
    home-manager.enable = true;
    alacritty = import ./config/alacritty.nix { inherit pkgs; inherit myConf; }; # <- https://github.com/guibou/nixGL
    #firefox = import ./config/firefox.nix;
    feh = import ./config/feh.nix;
    zsh = import ./config/zsh.nix { inherit pkgs; inherit myConf; };


    htop = {
      enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 10000;
      keyMode = "vi";
      shortcut = "y";
      terminal = "tmux-256color";
      customPaneNavigationAndResize = true;
      extraConfig = ''
        bind v split-window -h -c "#{pane_current_oath}"
        bind b split-window -v -c "#{pane_current_oath}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %
        set -g mouse on

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        unbind [
        bind < copy-mode
        unbind p
        bind > paste-buffer
        bind-key C-a set -g status off
        bind-key C-s set -g status on
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -M -X copy-pipe 'xclip -in -selection clipboard'

        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off
        set-window-option -g monitor-activity off
        set-option -g bell-action none
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = prefix-highlight;
        }
        
      ];
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

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

    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files";
      fileWidgetCommand = "fd --type f";
      changeDirWidgetCommand = "rg --files --null | xargs -0 dirname | sort -u";
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      #enableNixDirenvIntegration = true;
    };
  };

  home.username = "leon";
  home.homeDirectory = "/home/leon";

  home.stateVersion = "20.09";
}
