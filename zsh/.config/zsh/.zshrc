
# history config
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="/home/leon/.cache/zsh/history"
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
#setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

source "$ZDOTDIR/utils.zsh"


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


# clear the default keybinds, from utils.zsh
clear-keybinds

# load more stuff
source "$ZDOTDIR/fzf-tab.zsh"
source "$ZDOTDIR/keybinds.zsh"


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


# alias
alias ls="exa --icons"

# load prompt
source "$ZDOTDIR/prompt.zsh"

if command -v direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi
