if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then 
  . $HOME/.nix-profile/etc/profile.d/nix.sh; 
  export XDG_DATA_DIRS="$HOME/.nix-profile/share/applications:$HOME/.local/share/applications:/usr/local/share:/usr/share"
  export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' --no-out-link -A glibcLocales)/lib/locale/locale-archive
  export PATH="$HOME/.nix-profile/share/applications/:$PATH"
  export PATH="$HOME/.nix-profile/bin/:$PATH"
fi

export PATH="$HOME/.local/bin/scripts:$PATH"
export PATH="$HOME/.emacs.d/bin/:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cpm/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.nimble/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"


export EDITOR="$(which nvim)"
export BROWSER="$(which google-chrome-stable)"
#export TERMINAL="$(which alacritty)"
export TERMINAL="$(which foot)"


export RANGER_LOAD_DEFAULT_RC=FALSE

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --null | xargs -0 dirname | sort -u"

export LESSHISTFILE="/dev/null"

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"


# Man pages color support
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


export FREETYPE_PROPERTIES='truetype:interpreter-version=40'
export _JAVA_OPTIONS='-Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd'


export _JAVA_AWT_WM_NONREPARENTING=1

command -v opam > /dev/null && eval "$(opam env)"
command -v luarocks > /dev/null && eval "$(luarocks path --lua-version=5.4)"
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"

## Launches tbsm on session start
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  if command -v tbsm > /dev/null; then
    tbsm
  fi
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

. "$HOME/.local/share/../bin/env"
