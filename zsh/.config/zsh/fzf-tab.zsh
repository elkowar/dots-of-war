#!/usr/bin/env zsh

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
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:*:*' fzf-preview '/home/leon/scripts/preview.sh $realpath'


