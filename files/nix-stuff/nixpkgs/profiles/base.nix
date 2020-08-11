{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.base;
  elkowar_local = import ../local/default.nix {};
  myConf = import ../myConfig.nix;
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "Basic profile enabled";
    #useZsh = lib.mkEnableOption
  };

  imports = [ ../config/tmux.nix ../config/generalConfig.nix ../config/zsh.nix ];

  config = lib.mkIf cfg.enable {
    elkowar.programs.tmux.enable = true;
    elkowar.programs.zsh.enable = true;
    elkowar.generalConfig.shellAliases = {
      gc = "git commit";
    };

    home.packages = with pkgs; [
      direnv
      rnix-lsp
      nix-prefetch-git
      gtop
      bat
      websocat
      niv
      exa
      zsh-completions
      trash-cli
      mdcat
      github-cli
      haskellPackages.nix-tree
      ripgrep
      fd
      jq

      #(import (fetchTarball https://github.com/lf-/nix-doc/archive/main.tar.gz) {})
    ];

    programs = {
      home-manager.enable = true;
      htop.enable = true;

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

    home = {
      sessionVariables = rec {
        LOCALE_ARCHIVE_2_11 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";
        LOCALE_ARCHIVE = "/usr/bin/locale";

        EDITOR = "nvim";
        VISUAL = "nvim";
        GIT_EDITOR = EDITOR;
      };
      username = "leon";
      homeDirectory = "/home/leon";

      stateVersion = "20.09";

    };
  };
}
