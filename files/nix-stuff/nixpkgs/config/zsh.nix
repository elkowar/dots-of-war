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
    cnix = "cd ~/nixpkgs/ && nvim && cd -";
  };

  manFunction = ''
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
  '';

  fixedKeybinds = ''
    typeset -g -A key
    key[Home]="^[[H"
    key[End]="^[[F"
    key[Insert]="''${terminfo[kich1]}"
    key[Backspace]="''${terminfo[kbs]}"
    key[Delete]="''${terminfo[kdch1]}"
    key[Up]="''${terminfo[kcuu1]}"
    key[Down]="''${terminfo[kcud1]}"
    key[Left]="''${terminfo[kcub1]}"
    key[Right]="''${terminfo[kcuf1]}"
    key[PageUp]="''${terminfo[kpp]}"
    key[PageDown]="''${terminfo[knp]}"
    key[Shift-Tab]="''${terminfo[kcbt]}"

    # setup key accordingly
    [[ -n "''${key[Home]}"      ]] && bindkey -M vicmd "''${key[Home]}"      beginning-of-line                && bindkey -M viins "''${key[Home]}"      beginning-of-line
    [[ -n "''${key[End]}"       ]] && bindkey -M vicmd "''${key[End]}"       end-of-line                      && bindkey -M viins "''${key[End]}"       end-of-line
    [[ -n "''${key[Insert]}"    ]] && bindkey -M vicmd "''${key[Insert]}"    overwrite-mode                   && bindkey -M viins "''${key[Insert]}"    overwrite-mode
    [[ -n "''${key[Backspace]}" ]] && bindkey -M vicmd "''${key[Backspace]}" backward-delete-char             && bindkey -M viins "''${key[Backspace]}" backward-delete-char
    [[ -n "''${key[Delete]}"    ]] && bindkey -M vicmd "''${key[Delete]}"    delete-char                      && bindkey -M viins "''${key[Delete]}"    delete-char
    [[ -n "''${key[Up]}"        ]] && bindkey -M vicmd "''${key[Up]}"        up-line-or-history               && bindkey -M viins "''${key[Up]}"        up-line-or-history
    [[ -n "''${key[Down]}"      ]] && bindkey -M vicmd "''${key[Down]}"      down-line-or-history             && bindkey -M viins "''${key[Down]}"      down-line-or-history
    [[ -n "''${key[Left]}"      ]] && bindkey -M vicmd "''${key[Left]}"      backward-char                    && bindkey -M viins "''${key[Left]}"      backward-char
    [[ -n "''${key[Right]}"     ]] && bindkey -M vicmd "''${key[Right]}"     forward-char                     && bindkey -M viins "''${key[Right]}"     forward-char
    [[ -n "''${key[PageUp]}"    ]] && bindkey -M vicmd "''${key[PageUp]}"    beginning-of-buffer-or-history   && bindkey -M viins "''${key[PageUp]}"    beginning-of-buffer-or-history
    [[ -n "''${key[PageDown]}"  ]] && bindkey -M vicmd "''${key[PageDown]}"  end-of-buffer-or-history         && bindkey -M viins "''${key[PageDown]}"  end-of-buffer-or-history
    [[ -n "''${key[Shift-Tab]}" ]] && bindkey -M vicmd "''${key[Shift-Tab]}" reverse-menu-complete            && bindkey -M viins "''${key[Shift-Tab]}" reverse-menu-complete
  '';

  fzf-tab-stuff = ''

    FZF_TAB_COMMAND=(
        fzf
        --ansi
        --expect='$continuous_trigger' # For continuous completion
        '--color=hl:$(( $#headers == 0 ? 108 : 255 ))'
        --nth=2,3 --delimiter='\x00'  # Don't search prefix
        --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
        --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
        '--query=$query'   # $query will be expanded to query string at runtime.
        '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
    )
    zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

    zstyle ':completion:complete:*:options' sort false
    zstyle ':fzf-tab:complete:_zlua:*' query-string input

    local extract="
    local in=\''${\''${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
    local -A ctxt=(\"\''${(@ps:\2:)CTXT}\")
    local realpath=\''${ctxt[IPREFIX]}\''${ctxt[hpre]}\$in
    realpath=\''${(Qe)~realpath}
    "

    zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa --icons -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:nvim:*' extra-opts --preview=$extract'bat -p --color=always $realpath'

    #zstyle ':fzf-tab:complete:ls:*' extra-opts --preview=$extract'exa --icons -1 --color=always $realpath'
    #zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract'if [ -f $realpath ]; then bat -p --color=always $realpath; else exa --icons -1 --color=always $realpath; fi'


  '';

in
{
  enable = true;


  enableAutosuggestions = true;
  enableCompletion = true;
  dotDir = ".config/zsh";
  #defaultKeymap = "viins";
  history = {
    save = 10000;
    share = false;
    extended = true;
    ignoreDups = true;
    ignoreSpace = true;
  };

  localVariables = {
    #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "bg=${myConf.colors.accentDark}"; # why does this not work D:
    ZSH_AUTOSUGGEST_USE_ASYNC = 1;
  };

  shellAliases = {
    ls = "exa --icons";
  };

  initExtraBeforeCompInit = ''

    zstyle ':completion:*' menu select
    zstyle ':completion::complete:*' gain-privileges 1
    zstyle ':completion:*' list-prompt ""
    zstyle ':completion:*' select-prompt ""
    zmodload zsh/complist

    fpath+=( /usr/share/zsh/site-functions/ )
  '';

  initExtra = ''
    setopt nobeep

    setopt HIST_IGNORE_ALL_DUPS
    autoload -Uz colors && colors
    autoload -Uz promptinit && promptinit


    #_comp_options+=(globdots)

    # enable cdr command
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs

    # deer is a ranger-style file manager directly in the shell that doesn't fully context-switch
    #source ~/nixpkgs/config/deer.zsh
    #zle -N deer
    #bindkey '\ek' deer

    ${fzf-tab-stuff}
    ${fixedKeybinds}
    ${abbrs}
    ${manFunction}

    ${builtins.readFile ./prompt.zsh}
  '';

  plugins = let
    sources = import ./zsh/nix/sources.nix;
  in
    [
      { name = "fzf-tab"; src = sources.fzf-tab; }
      { name = "zsh-autosuggestions"; src = sources.zsh-autosuggestions; }
      { name = "history-substring-search"; src = sources.zsh-history-substring-search; }
      { name = "zsh-abbr"; src = sources.zsh-abbr; }
      { name = "fast-syntax-highlighting"; src = sources.fast-syntax-highlighting; }
    ];
}
