# ----------------------------------------------------------------------------
# .zshrc -- sourced for interactive zsh shells only.
# Pure env vars and PATH live in .zshenv.
# ----------------------------------------------------------------------------

# -------- history -----------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE      # commands prefixed with a space are NOT saved
setopt HIST_REDUCE_BLANKS     # strip superfluous blanks before saving
setopt HIST_VERIFY            # show !!-style expansions before running
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY          # implies INC_APPEND_HISTORY

[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"

source "$ZDOTDIR/utils.zsh"

# -------- zinit (plugin manager) -------------------------------------------
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

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# -------- completion --------------------------------------------------------
# compinit must run before fzf-tab, but fzf-tab must come before syntax
# highlighting. Run a full compinit at most once every 24 hours; otherwise
# use the cached dump for fast startup.
fpath=(~/.local/share/zsh/completions $fpath)
autoload -Uz compinit
if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# -------- plugins -----------------------------------------------------------
zinit light Aloxaf/fzf-tab

# Defer history-substring-search and bind its widgets *after* it loads,
# otherwise the bindkey calls run before the widgets exist.
zinit ice wait lucid atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    olets/zsh-abbr \
    sudosubin/zsh-github-cli \
    wfxr/forgit \
    pkulev/zsh-rustup-completion

# Clear default keybinds (clear-keybinds is defined in utils.zsh).
clear-keybinds

source "$ZDOTDIR/fzf-tab.zsh"
source "$ZDOTDIR/keybinds.zsh"

unalias zi 2>/dev/null

# -------- options -----------------------------------------------------------
setopt NOBEEP
setopt INTERACTIVE_COMMENTS

# -------- prompt ------------------------------------------------------------
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    source "$ZDOTDIR/prompt.zsh"
fi

# -------- tool integrations -------------------------------------------------
eval "$(zoxide init zsh)"
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v luarocks >/dev/null && eval "$(luarocks path)"

# fzf keybindings (installed via the fzf install script)
[ -f $HOME/.fzf/shell/key-bindings.zsh ] && . $HOME/.fzf/shell/key-bindings.zsh

# nvm (heavy; consider lazy-loading if startup feels sluggish)
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# sdkman
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# google cloud sdk
[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]       && . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

# 1Password SSH agent (macOS)
if [ -d "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t" ]; then
  export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

# -------- aliases -----------------------------------------------------------
if command -v lsd >/dev/null; then
    alias ls="lsd"
elif command -v eza >/dev/null; then
    alias ls="eza"
elif command -v exa >/dev/null; then
    alias ls="exa"
fi
alias ll="ls -lah"
alias dots="git -C $HOME/dots-of-war"
alias yk="yolk"
alias ygit="yolk git"
[[ -f '/Applications/Tailscale.app/Contents/MacOS/Tailscale' ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
command -v jless >/dev/null && alias yless="jless --yaml"
