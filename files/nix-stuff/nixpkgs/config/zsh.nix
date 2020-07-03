{ myConf, pkgs ? import <nixpkgs> }:
let
  makeAbbrs = with builtins; abbrs: concatStringsSep "\n"
    (
      attrValues
        (mapAttrs (k: v: ''abbr --session ${k}="${v}" >/dev/null 2>&1'') abbrs)
    );

  abbrs = makeAbbrs {
    gc = "git commit -m";
    gp = "git push";
    gaa = "git add --all";
    gs = "git status";
    cxmonad = "cd ~/.xmonad && nvim ~/.xmonad/lib/Config.hs && cd -";
  };

in
{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  defaultKeymap = "viins";
  dotDir = "~/.config";
  history = {
    save = 10000;
    share = true;
    ignoreDups = true;
    ignoreSpace = true;
  };

  localVariables = {
    #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "bg=${myConf.colors.accentDark}"; # why does this not work D:
  };

  initExtra = ''
    setopt HIST_IGNORE_ALL_DUPS
    autoload -Uz promptinit
    promptinit

    zstyle ":completion:*" menu select
    zstyle ':completion::complete:*' gain-privileges 1
    compinit
    _comp_options+=(globdots)


        
    function man() {
      env \
        LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
        LESS_TERMCAP_me=$(tput sgr0) \
        LESS_TERMCAP_mb=$(tput blink) \
        LESS_TERMCAP_us=$(tput setaf 2) \
        LESS_TERMCAP_ue=$(tput sgr0) \
        LESS_TERMCAP_so=$(tput smso) \
        LESS_TERMCAP_se=$(tput rmso) \
        PAGER="''${commands[less]:-$PAGER}" \
        man "$@"
    }

    #source ~/nixpkgs/config/deer.zsh
    #zle -N deer
    #bindkey '\ek' deer

    ${abbrs}
    ${builtins.readFile ./prompt.zsh}
  '';

  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "v0.6.4";
        sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
      };
    }

    {
      name = "history-substring-search";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-history-substring-search";
        rev = "v1.0.2";
        sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
      };
    }
    {
      name = "zsh-abbr";
      src = pkgs.fetchFromGitHub {
        owner = "olets";
        repo = "zsh-abbr";
        rev = "v3.3.3";
        sha256 = "0aln7ashadbgharfn4slhimbw624ai82p4yizsxwvz70y4dv0wpg";
      };
    }
    {
      # look at this https://github.com/zdharma/fast-syntax-highlighting
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
      };
    }
    {
      name = "fast-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zdharma";
        repo = "fast-syntax-highlighting";
        rev = "v1.55";
        sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
      };
    }
  ];
}
