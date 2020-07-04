local __bright_cyan="#8ec07c"
local __bright_white="#ebdbb2"
local __bright_green="#b8bb26"

dir() {
  local CUTOFF=3
  local IFS=/
  local my_path=($(print -P '%~'))
  local p
  for p in $my_path; do
    printf %s "${s}${p[0,$CUTOFF]}"
    local s=/
  done
  printf '%s\n' "${p:$CUTOFF}"
}

git_status() {
  local BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\s*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "(%F{$__bright_cyan}$BRANCH"
    [ ! -z "$(git status --short)" ] && echo -n "%F{$__bright_white}*%f"
    echo -n ")"
  fi
}

function _my_prompt() {

  echo -n "%F{$__bright_white}╭───"
  echo -n "%F{$__bright_cyan}$USER"
  echo -n "%F{$__bright_white} in"
  echo -n "%F{$__bright_green} $(dir)"
  echo -n "%F{$__bright_white} $(git_status)"
  echo
  # %3{stuff%} tell's zsh that the characters are printed as 3 chars wide
  echo -n "%3{╰─λ%} "
}


setopt prompt_subst
autoload -U colors && colors
PS1='$(_my_prompt)'
