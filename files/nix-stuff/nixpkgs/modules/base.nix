{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.base;
  elkowar_local = import ../local/default.nix { };
  myConf = import ../myConfig.nix;
  sources = import ../nix/sources.nix;
in
{
  options.elkowar.base = {
    enable = lib.mkEnableOption "Basic profile enabled";
    enableFish = lib.mkEnableOption "Fish shell";
    enableZsh = lib.mkEnableOption "Zsh shell";
  };

  imports = [ ./term ./generalConfig.nix ];

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
      (pkgs.callPackage ../packages/fet.sh.nix { })
      sources.manix
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
