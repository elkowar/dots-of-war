#!/usr/bin/env zsh

local __bright_cyan="#8ec07c"
local __bright_white="#ebdbb2"
local __bright_green="#b8bb26"

local CUTOFF=3

# black magic that reruns prompt whenever the vi mode changes {{{
function zle-line-init zle-keymap-select {
    case $KEYMAP in
      vicmd)      VI_INDICATOR="N";;
      main|viins) VI_INDICATOR="─";;
    esac
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select 
# }}}



function get_dir() {
  local IFS=/
  local my_path=$(print -P '%~')
  local p
  for p in $my_path; do
    printf %s "${s}${p[0,$CUTOFF]}"
    local s=/
  done
  printf '%s\n' "${p:$CUTOFF}"
}


function git_status() {
  local BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\s*\(.*\)/\1/' | tr -d ' ')

  if [ ! -z $BRANCH ]; then
    echo -n "(%F{$__bright_cyan}$BRANCH%F{$__bright_white}"
    [ ! -z "$(git status --short)" ] && echo -n "*"
    echo -n ")%f"
  fi
}

function _my_prompt() {
  local exit_code="$?"
  echo -n "%F{$__bright_white}╭─$VI_INDICATOR─"
  #echo -n "%F{$__bright_white}╭───"
  echo -n "%F{$__bright_cyan}$USER"
  echo -n "%F{$__bright_white} in"
  echo -n "%F{$__bright_green} $(get_dir)"
  echo -n "%F{$__bright_white} $(git_status)"
  if [ ! "$exit_code" = 0 ]; then
    echo -n "%F{red} REEEEEEEEEEE $exit_code"
  fi
  echo
  # %3{stuff%} tell's zsh that the characters are printed as 3 chars wide
  echo -n "%F{$__bright_white}%3{╰─λ%} "
}


setopt prompt_subst
autoload -U colors && colors
PS1='$(_my_prompt)'
