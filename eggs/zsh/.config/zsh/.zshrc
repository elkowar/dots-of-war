# history config
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.cache/zsh/history"
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
#setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

source "$ZDOTDIR/utils.zsh"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


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

# some magic to run compinit stuff only once a day, which should speed up zsh startup a good bit
autoload -Uz compinit
for dump in $ZSHDOTDIR/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# this would be the regular version of the above compinit code:
# compinit must be ran before fzf-tab, but fzf-tab must be before syntax highlighting etc
#autoload -Uz compinit
#compinit

zinit light "Aloxaf/fzf-tab"

zinit wait lucid for \
    "zsh-users/zsh-history-substring-search" \
    "zdharma-continuum/fast-syntax-highlighting" \
    "zsh-users/zsh-autosuggestions" \
    "olets/zsh-abbr" \
    "sudosubin/zsh-github-cli" \
    "wfxr/forgit" \
    "pkulev/zsh-rustup-completion"


# clear the default keybinds, from utils.zsh
clear-keybinds

# load more stuff
source "$ZDOTDIR/fzf-tab.zsh"
source "$ZDOTDIR/keybinds.zsh"

unalias zi

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
if command -v lsd >/dev/null; then
    alias ls="lsd"
elif command -v exa >/dev/null; then
    alias ls="exa"
fi
alias dots="git -C $HOME/dots-of-war"

# load prompt
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
else
    source "$ZDOTDIR/prompt.zsh"
fi

if command -v direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi
if command -v luarocks >/dev/null; then
    eval "$(luarocks path)"
fi

export EDITOR=nvim
export VISUAL=nvim



export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK="$HOME/Android/Sdk/ndk/21.4.7075529"
export JAVA_HOME="/usr/lib/jvm/java-1.19.0-openjdk-amd64/"



if [ -d "$HOME/anaconda3" ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi

export PATH="$HOME/.volta/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"


export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if [ -d "/Applications/WezTerm.app" ]; then
    export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
fi

if command -v flutter >/dev/null; then
    export PATH="$HOME/.pub-cache/bin:$PATH"
fi
[[ -d "$HOME/.deno/bin" ]] && export PATH="$HOME/.deno/bin:$PATH"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -f '~/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '~/Downloads/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '~/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '~/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

[[ -f '/Applications/Tailscale.app/Contents/MacOS/Tailscale' ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
command -v jless >/dev/null && alias yless="jless --yaml"
