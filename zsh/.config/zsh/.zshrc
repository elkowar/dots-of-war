
# history config
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$XDG_CACHE_HOME"/zsh/history
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
#setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY



# plugins
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "Aloxaf/fzf-tab", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "olets/zsh-abbr"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load


# load more stuff
source "$ZDOTDIR/fzf-tab.zsh"


# fzf keybindings
[ -f $HOME/.fzf/shell/key-bindings.zsh ] && . $HOME/.fzf/shell/key-bindings.zsh


# some more options
setopt NOBEEP
setopt INTERACTIVE_COMMENTS


# ET nvim as manpager
export MANPAGER='nvim +Man! +"set nocul" +"set noshowcmd" +"set noruler" +"set noshowmode" +"set laststatus=0"'


autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

# epic keybinds

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
bindkey '^H' backward-delete-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# alias
alias ls="exa --icons"

# load prompt
source "$ZDOTDIR/prompt.zsh"
