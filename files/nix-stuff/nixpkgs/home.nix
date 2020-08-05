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
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    cool-retro-term = (
      pkgs.writeScriptBin "cool-retro-term" ''
        #!/bin/sh
        exec nixGLIntel ${pkgs.cool-retro-term}/bin/cool-retro-term "$@"
      ''
    );
  };



  home.packages = with pkgs; [
    elkowar_local.bashtop
    direnv
    rnix-lsp
    nix-prefetch-git
    gtop
    simplescreenrecorder
    bat
    websocat
    niv
    exa
    gromit-mpx
    zsh-completions
    cool-retro-term
    ghc

    mdcat
    github-cli
    tdesktop
    #hyper-haskell
  ];

  gtk = import ./config/gtk.nix { inherit pkgs; inherit myConf; };

  programs = {
    home-manager.enable = true;
    alacritty = import ./config/alacritty.nix { inherit pkgs; inherit myConf; }; # <- https://github.com/guibou/nixGL
    zsh = import ./config/zsh.nix { inherit pkgs; inherit myConf; };
    tmux = import ./config/tmux.nix { inherit pkgs; inherit myConf; };
    feh = import ./config/feh.nix;

    htop.enable = true;

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
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/leon/Downloads/music";
    };
    udiskie.enable = true;
  };


  home.sessionVariables = {
    LOCALE_ARCHIVE_2_11 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    LOCALE_ARCHIVE = "/usr/bin/locale";
  };
  home.username = "leon";
  home.homeDirectory = "/home/leon";

  home.stateVersion = "20.09";
}
