source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "Aloxaf/fzf-tab", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

eval "$(zoxide init zsh)"

source "$ZDOTDIR/fzf-tab.zsh"


setopt nobeep
setopt HIST_IGNORE_ALL_DUPS
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
bindkey '^H' backward-delete-word


alias ls="exa --icons"


source "$ZDOTDIR/prompt.zsh"
