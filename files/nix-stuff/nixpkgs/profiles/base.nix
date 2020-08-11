{ config, lib, pkgs, ... }:
let
  cfg = config.profiles.base;
  elkowar_local = import ../local/default.nix {};
  myConf = import ../myConfig.nix;
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "Basic profile enabled";
    enableFish = lib.mkEnableOption "Fish shell";
    enableZsh = lib.mkEnableOption "Zsh shell";
  };

  imports = [ ../config/tmux.nix ../config/generalConfig.nix ../config/zsh.nix ../config/fish.nix ];

  config = lib.mkIf cfg.enable {
    elkowar.programs.tmux.enable = true;
    elkowar.programs.zsh.enable = cfg.enableZsh;
    elkowar.programs.fish.enable = cfg.enableFish;
    elkowar.generalConfig.shellAbbrs = {
        vim = "nvim";
        tsh = "trash";
        cxmonad = "nvim /home/leon/.xmonad/lib/Config.hs";
        cnix = "cd ~/nixpkgs/ && nvim home.nix && cd -";

        gaa = "git add --all";
        gc = "git commit -m ";
        gp = "git push";
        gs = "git status";
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
        enableFishIntegration = cfg.enableFish;
        enableZshIntegration = cfg.enableZsh;
        defaultCommand = "rg --files";
        fileWidgetCommand = "fd --type f";
        changeDirWidgetCommand = "rg --files --null | xargs -0 dirname | sort -u";
      };

      direnv = {
        enable = true;
        enableFishIntegration = cfg.enableFish;
        enableZshIntegration = cfg.enableZsh;
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
