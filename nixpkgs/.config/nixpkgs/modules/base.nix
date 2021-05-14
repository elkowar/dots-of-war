{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.base;
  elkowar_local = import ../local/default.nix {};
  sources = import ../nix/sources.nix;

  addFlags = package: name: flags: pkgs.symlinkJoin {
    name = name;
    paths = [ package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${name} --add-flags "${flags}"
    '';
  };
in
{
  options.elkowar.base = {
    enable = lib.mkEnableOption "Basic profile enabled";
    enableFish = lib.mkEnableOption "Fish shell";
    enableZsh = lib.mkEnableOption "Zsh shell";
    includeNiceToHaves = lib.mkEnableOption "Add nice-to-have, non-essential programs";
    includeHaskellDev = lib.mkEnableOption "Include large haskell development packages";
  };

  imports = [ ./term ./generalConfig.nix ];

  config = lib.mkIf cfg.enable {
    elkowar.programs.tmux.enable = true;
    elkowar.programs.zsh.enable = cfg.enableZsh;
    elkowar.programs.fish.enable = cfg.enableFish;
    elkowar.generalConfig.shellAbbrs = {
      vim = "nvim";
      cxmonad = "cd ~/.xmonad && nvim /home/leon/.xmonad/lib/Config.hs && cd -";
      cnix = "cd ~/.config/nixpkgs/ && nvim home.nix && cd -";
      cvim = "cd ~/.config/nvim/ && nvim fnl/init.fnl && cd -";

      ra = "ranger";

      gaa = "git add --all";
      gc = "git commit -m ";
      gp = "git push";
      gst = "git status";
      g = "git fuzzy";
      cr = "cargo run --";
    };

    home.packages = with pkgs; lib.mkMerge [
      [
        sources.manix
        direnv
        rnix-lsp
        niv
        exa
        trash-cli
        ripgrep
        fd
        jq
        nodejs
        nodePackages.bash-language-server
        nodePackages.dockerfile-language-server-nodejs
        cargo-outdated
        manix
        catimg
        bat

        cachix
      ]
      (
        lib.mkIf cfg.includeNiceToHaves [
          (addFlags glow "glow" "--style ~/.config/glowStyle.json")
          mdcat
          haskellPackages.nix-tree
          cloc
          fet-sh
          github-cli
          websocat
          gtop
          nix-prefetch
          cargo-bloat
          sccache
          bpytop
          cargo-watch
          cargo-expand
          gdbgui
          lldb
          zola
          python38Packages.pylint
          gitAndTools.gitflow
          gitAndTools.tig
          gitAndTools.gitui
          #pakcs
          rlwrap
          irssi
          hexchat
          swiPrologWithGui
          kmonad
          gitAndTools.delta
          git-fuzzy
        ]
      )
      (
        lib.mkIf cfg.includeHaskellDev [
          cabal2nix
          cabal-install
          ormolu
        ]
      )
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
