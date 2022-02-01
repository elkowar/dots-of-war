
# history config
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$XDG_CACHE_HOME"/zsh/history
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
#setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY



### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk


# if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#     print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
#     command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
#         print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
#         print -P "%F{160}▓▒░ The clone has failed.%f%b"
# fi
# 
# source "$HOME/.zinit/bin/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
# 
# zinit snippet OMZP::git
# zinit wait lucid for "zsh-users/zsh-completions"

# compinit must be ran before fzf-tab, but fzf-tab must be before syntax highlighting etc
autoload -Uz compinit
compinit

zinit light "Aloxaf/fzf-tab"

zinit wait lucid for \
    "zsh-users/zsh-history-substring-search" \
    "zdharma-continuum/fast-syntax-highlighting" \
    "zsh-users/zsh-autosuggestions" \
    "olets/zsh-abbr" \
    "sudosubin/zsh-github-cli" \
    "pkulev/zsh-rustup-completion"


# load more stuff
source "$ZDOTDIR/fzf-tab.zsh"


eval "$(zoxide init zsh)"


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
bindkey "^[." insert-last-word

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# alias
alias ls="exa --icons"

# load prompt
source "$ZDOTDIR/prompt.zsh"

if command -v direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi
